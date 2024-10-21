//
//  IndividualGroupView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import SwiftUI

struct IndividualGroupView: View {
    
    var group: Group
    
    var body: some View {
        Text(group.name)
    }
}

#Preview {
    IndividualGroupView(group: Group(name: "Dune", creationDate: Date.now, imageData: nil))
}
