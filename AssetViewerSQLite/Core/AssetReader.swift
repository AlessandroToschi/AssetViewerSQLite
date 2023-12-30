//
//  AssetReader.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation

protocol AssetReader {
  func getAssets() -> [Asset]
  
  func getAssetData(id: String) -> [UInt8]
}
