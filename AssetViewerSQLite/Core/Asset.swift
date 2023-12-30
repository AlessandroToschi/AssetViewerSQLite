//
//  File.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 29/12/23.
//

import Foundation

struct Asset: Identifiable, Hashable {
  var id: String
  var width: Int
  var height: Int
  var duration: Double?
  
  var isVideo: Bool {
    return self.duration != nil
  }
  
  internal init(
    id: String,
    width: Int,
    height: Int,
    duration: Double? = nil
  ) {
    self.id = id
    self.width = width
    self.height = height
    self.duration = duration
  }
}


struct AssetData: Identifiable, Hashable {
  var id: String
  var data: [UInt8]
  
  internal init(
    id: String,
    data: [UInt8]
  ) {
    self.id = id
    self.data = data
  }
}
