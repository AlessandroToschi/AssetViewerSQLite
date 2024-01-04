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
  var analytics: String
  
  @ObservationIgnored
  private var assetReader: AssetReader
  
  @ObservationIgnored
  private var assetWriter: AssetWriter
  
  @ObservationIgnored
  private var clock: ContinuousClock
  
  init(
    assetReader: AssetReader,
    assetWriter: AssetWriter
  ) {
    self.assets = []
    self.assetsData = []
    self.analytics = ""
    self.assetReader = assetReader
    self.assetWriter = assetWriter
    self.clock = ContinuousClock()
  }
  
  func load() {
    self.measureElapsedTime {
      self.assets = self.assetReader.getAssets()
    }
  }
  
  func loadData(assetId: String) {
    self.measureElapsedTime {
      guard self.assetsData.firstIndex(where: { $0.id == assetId }) == nil
      else { return }
      self.assetsData.append(
        AssetData(
          id: assetId,
          data: self.assetReader.getAssetData(id: assetId)
        )
      )
    }
  }
  
  func unloadData(assetId: String) {
    self.assetsData.removeAll{ $0.id == assetId }
  }
  
  func add(asset: Asset, assetData: [UInt8]) {
    self.measureElapsedTime {
      self.assetWriter.add(asset: asset, assetData: assetData)
    }
  }
  
  func asset(assetId: String) -> Asset {
    return self.assets.first{ $0.id == assetId }!
  }
  
  func assetData(assetId: String) -> AssetData? {
    return self.assetsData.first{ $0.id == assetId }
  }
  
  func delete(assetId: String) {
    self.assetWriter.delete(assetId: assetId)
  }
  
  private func measureElapsedTime(work: @escaping () -> ()) {
    let duration = self.clock.measure(work)
    self.analytics = "Elapsed time: \(duration.inMicroseconds) μs"
  }
}

extension Duration {
  var inMilliseconds: Double {
    return Double(self.components.seconds) * 1000.0 + Double(self.components.attoseconds) * 1E-15
  }
  
  var inMicroseconds: Double {
    return Double(self.components.seconds) * 1000.0 + Double(self.components.attoseconds) * 1E-12
  }
}
