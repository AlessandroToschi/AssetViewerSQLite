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
  private var getAssetDataQuery: Table
  
  init(connection: Connection) {
    self.connection = connection
    self.getAssetsQuery = AssetsTable.table.select([
      AssetsTable.id,
      AssetsTable.width,
      AssetsTable.height,
      AssetsTable.duration
    ])
    self.getAssetDataQuery = AssetsTable.table.select([AssetsTable.data])
  }
  
  func getAssets() -> [Asset] {
    let startTime = DispatchTime.now()
    defer {
      let endTime = DispatchTime.now()
      let elapsedTime = (endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
      print("\(#function): \(elapsedTime) ms")
    }
    guard let rows = try? connection.prepare(self.getAssetsQuery)
    else { return [] }
    return rows.map(Asset.fromRow)
  }
  
  func getAssetData(id: String) -> [UInt8] {
    let startTime = DispatchTime.now()
    defer {
      let endTime = DispatchTime.now()
      let elapsedTime = (endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
      print("\(#function): \(elapsedTime) ms")
    }
    guard let row = try? connection.pluck(self.getAssetDataQuery.where(AssetsTable.id == id))
    else { return [] }
    return row[AssetsTable.data]!.bytes
  }
}
