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
  
  func add(asset: Asset) {
    self.assetWriter.add(asset: asset)
  }
}