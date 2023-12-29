//
//  AssetViewerSQLiteApp.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import SwiftUI
import SQLite

@main
struct AssetViewerSQLiteApp: App {
  let assetManager: AssetManager
  
  init() {
    let dbPath = Bundle.main.path(forResource: "AssetViewer", ofType: "sqlite")!
    let connection = try! Connection(dbPath)
    let assetReader = AssetReaderSQLite(connection: connection)
    let assetWriter = AssetWriterSQLite(connection: connection)
    
    self.assetManager = AssetManager(
      assetReader: assetReader,
      assetWriter: assetWriter
    )
  }
  
  var body: some Scene {
    WindowGroup {
      AssetsPage()
        .environment(self.assetManager)
    }
  }
}
