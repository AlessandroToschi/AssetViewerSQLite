//
//  AssetManager.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation
import Observation

@Observable
class AssetManager {
  var assets: [Asset]
  
  @ObservationIgnored
  private var assetReader: AssetReader
  
  @ObservationIgnored
  private var assetWriter: AssetWriter
  
  init(
    assetReader: AssetReader,
    assetWriter: AssetWriter
  ) {
    self.assets = []
    self.assetReader = assetReader
    self.assetWriter = assetWriter
  }
  
  func load() {
    self.assets = self.assetReader.getAssets()
  }
  
  func loadData(for assetId: String) {
    guard let assetIndex = self.assets.firstIndex(where: { $0.id == assetId })
    else { return }
    
    self.assets[assetIndex].data = self.assetReader.getAssetData(id: assetId)
  }
  
  func add(asset: Asset) {
    self.assetWriter.add(asset: asset)
  }
}
