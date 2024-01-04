//
//  AssetRow.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 03/01/24.
//

import SwiftUI

struct AssetRow: View {
  var asset: Asset
  
  var body: some View {
    HStack {
      self.asset.icon
      VStack(alignment: .leading) {
        Text(self.asset.id)
        Text(self.asset.description)
      }
      Spacer()
    }
  }
}

fileprivate var numberFormatter = {
  let numberFormatter = NumberFormatter()
  numberFormatter.maximumFractionDigits = 2
  numberFormatter.numberStyle = .decimal
  return numberFormatter
}()


private extension Asset {
  var icon: Image {
    return self.isVideo ? Image(systemName: "video") : Image(systemName: "photo.on.rectangle")
  }
  
  var description: String {
    var assetDescription = "\(self.width)x\(self.height)"
    if let duration {
      assetDescription += " - \(numberFormatter.string(from: NSNumber(value: duration))!) s"
    }
    return assetDescription
  }
}
