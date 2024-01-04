//
//  AssetsPage.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import SwiftUI
import PhotosUI
import CoreTransferable

struct AssetsPage: View {
  @Environment(AssetManager.self) var assetManager
  @State var selectedPickerItem: PhotosPickerItem?
  @State var selectedAssetId: String?
  @State var isLoading: Bool = false
  
  var photoPicker: some View {
    PhotosPicker(
      selection: self.$selectedPickerItem,
      matching: .any(of: [.images, .videos])
    ) {
      Image(systemName: "plus")
    }
  }
  
  func loadAssets() {
    self.assetManager.load()
  }
  
  func onDelete(indexSet: IndexSet) {
    self.isLoading = true
    defer {
      self.isLoading = false
    }
    for index in indexSet {
      let assetId = self.assetManager.assets[index].id
      self.assetManager.delete(assetId: assetId)
      self.assetManager.unloadData(assetId: assetId)
    }
    self.assetManager.load()
  }
  
  func onPickerItemChange() {
    Task { @MainActor in
      if let selectedPickerItem {
        self.isLoading = true
        
        var newAsset: Asset? = nil
        var newAssetData: [UInt8]? = nil
        
        guard let data = try? await selectedPickerItem.loadTransferable(type: Data.self)
        else { return }
        
        if selectedPickerItem.supportedContentTypes.contains(where: { $0.conforms(to: .image) }),
           let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
           let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
           let width = imageProperties[kCGImagePropertyPixelWidth] as? Int,
           let height = imageProperties[kCGImagePropertyPixelHeight] as? Int{
          newAsset = Asset(
            id: UUID.short(),
            width: width,
            height: height
          )
          newAssetData = [UInt8](data)
        } else if selectedPickerItem.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }),
                  let type = selectedPickerItem.supportedContentTypes.first {
          let path = URL.temporaryDirectory.appending(path: "\(UUID.short()).\(type.preferredFilenameExtension ?? "mov")")
          
          try? data.write(to: path, options: .atomic)
          
          defer {
            try? FileManager.default.removeItem(at: path)
          }
          
          let asset = AVURLAsset(url: path)
          let videoTrack = try! await asset.loadTracks(withMediaType: .video).first!
          let size = try! await videoTrack.load(.naturalSize)
          let duration = try! await videoTrack.load(.timeRange).duration.seconds
          newAsset = Asset(
            id: UUID.short(),
            width: Int(size.width),
            height: Int(size.height),
            duration: duration
          )
          newAssetData = [UInt8](data)
        }
        
        if let newAsset,
           let newAssetData {
          self.assetManager.add(asset: newAsset, assetData: newAssetData)
          self.assetManager.load()
        }
      }
      
      self.selectedPickerItem = nil
      self.isLoading = false
    }
  }
  
  func onSelectedAssetChange() {
    if let selectedAssetId {
      self.assetManager.loadData(assetId: selectedAssetId)
    }
  }
  
  var body: some View {
    NavigationView {
      NavigationSplitView(
        sidebar: {
          List(selection: $selectedAssetId) {
            ForEach(self.assetManager.assets, id: \.id) {
              asset in
              NavigationLink(value: asset.id) {
                AssetRow(asset: asset)
              }
            }
            .onDelete(perform: self.onDelete(indexSet:))
          }
          .navigationTitle("Assets")
          .toolbar { self.photoPicker }
          .onAppear(perform: self.loadAssets)
          .refreshable(action: self.loadAssets)
          .onChange(of: self.selectedPickerItem, self.onPickerItemChange)
          .onChange(of: self.selectedAssetId, self.onSelectedAssetChange)
        },
        detail: {
          if let selectedAssetId {
            AssetDetail(assetId: selectedAssetId)
          } else {
            Text("Please, select an asset.")
          }
        }
      )
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Text(self.assetManager.analytics)
        }
      }
    }.overlay {
      if self.isLoading {
        LoadingOverlay()
      } else {
        EmptyView()
      }
    }
  }
}

extension UUID {
  static func short(maxLength: Int = 6) -> String {
    return String(UUID().uuidString.prefix(maxLength))
  }
}

