//
//  AssetReaderSQLite.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation
import SQLite

class AssetReaderSQLite: AssetReader {
  private var connection: Connection
  private var getAssetsQuery: Table
  
  init(connection: Connection) {
    self.connection = connection
    self.getAssetsQuery = AssetsTable.table.select([
      AssetsTable.id,
      AssetsTable.width,
      AssetsTable.height,
      AssetsTable.duration
    ])
  }
  
  func getAssets() -> [Asset] {
    let startTime = DispatchTime.now()
    defer {
      let endTime = DispatchTime.now()
      let elapsedTime = (endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
      print("\(#function): \(elapsedTime) ms")
    }
    guard let assets = try? connection.prepare(self.getAssetsQuery)
    else { return [] }
    return assets.map(Asset.fromRow)
  }
}
