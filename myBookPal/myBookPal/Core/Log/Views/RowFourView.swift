//
//  RowFourView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/12/24.
//

import SwiftUI

struct RowFourView: View {
    var textOne: String
    var textTwo: String
    
    @Binding var tagArray: [Tag]
    
    @State var tag = Tag(text: "", color: "")
    @State var tag2 = Tag(text: "", color: "")
    
    var arrayLimit = 3
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.accent)
                    .frame(width: 140, height: 30)
                    .padding(.vertical, -10)
                    .overlay {
                        Text(textOne)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        tag.text = textOne
                        tag.color = ".accent"
                        
                        if tagArray.count != arrayLimit && !tagArray.contains(tag)  {
                            tagArray.append(tag)
                        }
                    }
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.complement)
                    .frame(width: 80, height: 30)
                    .overlay {
                        Text(textTwo)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        tag2.text = textTwo
                        tag2.color = ".complement"
                        
                        if tagArray.count != arrayLimit && !tagArray.contains(tag2)  {
                            tagArray.append(tag2)
                        }
                    }
            }
        }
    }
}

#Preview {
    RowFourView(textOne: "Thought-Provoking", textTwo: "Plot-Twist", tagArray: .constant([Tag(text: "", color: ""), Tag(text: "", color: ""), Tag(text: "", color: "")]))
}
