//
//  AddGoalView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import SwiftUI

struct AddGoalView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is add goal view!")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Goal")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    AddGoalView()
}
