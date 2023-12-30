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
  var assetsData: [AssetData]
  
  @ObservationIgnored
  private var assetReader: AssetReader
  
  @ObservationIgnored
  private var assetWriter: AssetWriter
  
  init(
    assetReader: AssetReader,
    assetWriter: AssetWriter
  ) {
    self.assets = []
    self.assetsData = []
    self.assetReader = assetReader
    self.assetWriter = assetWriter
  }
  
  func load() {
    self.assets = self.assetReader.getAssets()
  }
  
  func loadData(assetId: String) {
    guard self.assetsData.firstIndex(where: { $0.id == assetId }) == nil
    else { return }
    self.assetsData.append(
      AssetData(
        id: assetId,
        data: self.assetReader.getAssetData(id: assetId)
      )
    )
  }
  
  func add(asset: Asset, assetData: [UInt8]) {
    self.assetWriter.add(asset: asset, assetData: assetData)
  }
  
  func asset(assetId: String) -> Asset {
    return self.assets.first{ $0.id == assetId }!
  }
  
  func assetData(assetId: String) -> AssetData? {
    return self.assetsData.first{ $0.id == assetId }
  }
}
