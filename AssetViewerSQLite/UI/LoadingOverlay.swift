//
//  LoadingOverlay.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 30/12/23.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
      ZStack {
        Rectangle()
          .ignoresSafeArea()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.ultraThinMaterial)
        ProgressView()
          .controlSize(.extraLarge)
          .tint(.white)
      }
    }
}

#Preview {
    LoadingOverlay()
}
