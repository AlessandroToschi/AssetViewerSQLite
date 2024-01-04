//
//  LoadingOverlay.swift
//  AssetViewerSQLite
//
//  Created by Alessandro Toschi on 30/12/23.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
      Color.clear
        .background(.ultraThinMaterial)
        .overlay() {
          ProgressView()
            .controlSize(.extraLarge)
        }.ignoresSafeArea()
    }
}

#Preview {
    LoadingOverlay()
}
