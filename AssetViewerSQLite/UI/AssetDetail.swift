//
//  AssetDetail.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 30/12/23.
//

import SwiftUI
import AVKit

struct AssetDetail: View {
  @Environment(AssetManager.self) var assetManager
  var assetId: String
  
  @State var player: AVPlayer?
  
  var body: some View {
    let asset = self.assetManager.asset(assetId: self.assetId)
    let assetData = self.assetManager.assetData(assetId: self.assetId)
    Group {
      if let assetData {
        if asset.isVideo {
          if let player {
            VideoPlayer(player: player)
          } else {
            Text(self.assetId)
          }
        } else {
          if let uiImage = UIImage(data: Data(assetData.data)) {
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fit)
          } else {
            Text(self.assetId)
          }
        }
      } else {
        LoadingOverlay()
      }
    }
    .task {
      if asset.isVideo, let assetData {
        let videoUrl = URL.temporaryDirectory.appending(path: "movie.mov")
        try! Data(assetData.data).write(to: videoUrl, options: .atomic)
        self.player = AVPlayer(url: videoUrl)
      }
    }
  }
}
