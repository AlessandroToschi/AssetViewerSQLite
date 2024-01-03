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
  
  var body: some View {
    NavigationSplitView(
      sidebar: {
        List(selection: $selectedAssetId) {
          ForEach(self.assetManager.assets, id: \.id) {
            asset in
            NavigationLink(value: asset.id) {
              HStack {
                asset.icon
                VStack(alignment: .leading) {
                  Text(asset.id)
                  Text(asset.description)
                }
                Spacer()
              }
            }
          }.onDelete {
            indexSet in
            for index in indexSet {
              let assetId = self.assetManager.assets[index].id
              self.assetManager.delete(assetId: assetId)
              self.assetManager.unloadData(assetId: assetId)
            }
            self.assetManager.load()
          }
        }
        .navigationTitle("Assets")
        .toolbar {
          PhotosPicker(
            selection: self.$selectedPickerItem,
            matching: .any(of: [.images, .videos])
          ) {
            Image(systemName: "plus")
          }
        }
        .onAppear() {
          self.assetManager.load()
        }
        .refreshable {
          self.assetManager.load()
        }
        .onChange(of: self.selectedPickerItem) {
          Task { @MainActor in
            if let selectedPickerItem {
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
                  id: UUID().uuidString,
                  width: width,
                  height: height
                )
                newAssetData = [UInt8](data)
              } else if selectedPickerItem.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }),
                        let type = selectedPickerItem.supportedContentTypes.first {
                let path = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).\(type.preferredFilenameExtension ?? "mov")")
                
                try? data.write(to: path, options: .atomic)
                
                defer {
                  try? FileManager.default.removeItem(at: path)
                }
                
                let asset = AVURLAsset(url: path)
                let videoTrack = try! await asset.loadTracks(withMediaType: .video).first!
                let size = try! await videoTrack.load(.naturalSize)
                let duration = try! await videoTrack.load(.timeRange).duration.seconds
                newAsset = Asset(
                  id: UUID().uuidString,
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
          }
        }
        .onChange(of: self.selectedAssetId) {
          if let selectedAssetId {
            self.assetManager.loadData(assetId: selectedAssetId)
          }
        }
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
        Spacer()
      }
    }
  }
}

fileprivate var numberFormatter = {
  let numberFormatter = NumberFormatter()
  numberFormatter.maximumFractionDigits = 2
  numberFormatter.numberStyle = .decimal
  return numberFormatter
}()

private extension Asset {
  var icon: Image {
    return self.isVideo ? Image(systemName: "video") : Image(systemName: "photo.on.rectangle")
  }
  
  var description: String {
    var assetDescription = "\(self.width)x\(self.height)"
    if let duration {
      assetDescription += " - \(numberFormatter.string(from: NSNumber(value: duration))!) s"
    }
    return assetDescription
  }
}
