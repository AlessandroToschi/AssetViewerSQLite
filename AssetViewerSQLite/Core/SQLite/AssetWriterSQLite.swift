//
//  AssetWriterSQLite.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation
import SQLite

class AssetWriterSQLite: AssetWriter {
  private var connection: Connection
  
  init(connection: Connection) {
    self.connection = connection
  }
  
  func add(asset: Asset) {
    let startTime = DispatchTime.now()
    defer {
      let endTime = DispatchTime.now()
      let elapsedTime = (endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
      print("\(#function): \(elapsedTime) ms")
    }
    try? self.connection.run(
      AssetsTable.table.insert([
        AssetsTable.id <- asset.id,
        AssetsTable.width <- asset.width,
        AssetsTable.height <- asset.height,
        AssetsTable.duration <- asset.duration,
        AssetsTable.data <- asset.data.flatMap(Blob.init(bytes:))
      ])
    )
  }
}
