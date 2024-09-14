//
//  RowTwoView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/12/24.
//

import SwiftUI

struct RowTwoView: View {
    var textOne: String
    var textTwo: String
    var textThree: String
    var textFour: String
    
    @Binding var tagArray: [Tag]
    
    @State var tag = Tag(text: "", color: "")
    @State var tag2 = Tag(text: "", color: "")
    @State var tag3 = Tag(text: "", color: "")
    @State var tag4 = Tag(text: "", color: "")
    
    var arrayLimit = 3
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.accent)
                    .frame(width: 90, height: 30)
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
                    .fill(.accent)
                    .frame(width: 60, height: 30)
                    .overlay {
                        Text(textTwo)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        tag2.text = textTwo
                        tag2.color = ".accent"
                        
                        if tagArray.count != arrayLimit && !tagArray.contains(tag2)  {
                            tagArray.append(tag2)
                        }
                    }
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.complement)
                    .frame(width: 100, height: 30)
                    .overlay {
                        Text(textThree)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        tag3.text = textThree
                        tag3.color = ".complement"
                        
                        if tagArray.count != arrayLimit && !tagArray.contains(tag3)  {
                            tagArray.append(tag3)
                        }
                    }
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.accent)
                    .frame(width: 110, height: 30)
                    .overlay {
                        Text(textFour)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        tag4.text = textFour
                        tag4.color = ".accent"
                        
                        if tagArray.count != arrayLimit && !tagArray.contains(tag4) {
                            tagArray.append(tag4)
                        }
                    }
            }
        }
    }
}

#Preview {
    RowTwoView(textOne: "Suspenseful", textTwo: "Intense", textThree: "Controversial", textFour: "Heartwarming", tagArray: .constant([Tag(text: "", color: ""), Tag(text: "", color: ""), Tag(text: "", color: "")]))
}
