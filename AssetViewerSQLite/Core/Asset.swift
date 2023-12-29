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
  var data: [UInt8]?
  
  var isVideo: Bool {
    return self.duration != nil
  }
  
  internal init(
    id: String,
    width: Int,
    height: Int,
    duration: Double? = nil,
    data: [UInt8]? = nil
  ) {
    self.id = id
    self.width = width
    self.height = height
    self.duration = duration
    self.data = data
  }
}
