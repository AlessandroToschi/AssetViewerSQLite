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
    let documentDbPath = URL.documentsDirectory.appending(path: "AssetViewer.sqlite")
    
    if !FileManager.default.fileExists(atPath: documentDbPath.path()) {
      let dbPath = Bundle.main.url(forResource: "AssetViewer", withExtension: "sqlite")!
      try? FileManager.default.copyItem(at: dbPath, to: documentDbPath)
    }
    
    let connection = try! Connection(documentDbPath.absoluteString, readonly: false)
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
