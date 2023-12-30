//
//  AssetWriter.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation

protocol AssetWriter {
  func add(asset: Asset, assetData: [UInt8])
}
