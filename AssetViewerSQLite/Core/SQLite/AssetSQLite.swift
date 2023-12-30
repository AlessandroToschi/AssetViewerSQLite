//
//  AssetSQLite.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation
import SQLite

struct AssetsTable {
  static let table = Table("assets")
  static let id = Expression<String>("id")
  static let width = Expression<Int>("width")
  static let height = Expression<Int>("height")
  static let duration = Expression<Double?>("duration")
}

extension Asset {
  static func fromRow(row: Row) -> Asset {
    return Asset(
      id: row[AssetsTable.id],
      width: row[AssetsTable.width],
      height: row[AssetsTable.height],
      duration: row[AssetsTable.duration]
    )
  }
}

struct AssetsDataTable {
  static let table = Table("assets_data")
  static let id = Expression<String>("id")
  static let data = Expression<Blob>("data")
}
