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
    self.getAssetDataQuery = AssetsDataTable.table.select([AssetsDataTable.data])
  }
  
  func getAssets() -> [Asset] {
    guard let rows = try? connection.prepare(self.getAssetsQuery)
    else { return [] }
    return rows.map(Asset.fromRow)
  }
  
  func getAssetData(id: String) -> [UInt8] {
    guard let row = try? connection.pluck(self.getAssetDataQuery.where(AssetsDataTable.id == id))
    else { return [] }
    return row[AssetsDataTable.data].bytes
  }
}
