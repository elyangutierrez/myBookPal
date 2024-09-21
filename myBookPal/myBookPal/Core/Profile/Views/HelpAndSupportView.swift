//
//  HelpAndSupportView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/20/24.
//

import SwiftUI

struct HelpAndSupportView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Help & Support View!")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Cancel")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}

#Preview {
    HelpAndSupportView()
}
