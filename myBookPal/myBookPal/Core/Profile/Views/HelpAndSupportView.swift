//
//  HelpAndSupportView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/20/24.
//

import SwiftUI

struct HelpAndSupportView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool
    
    @State private var descriptionText = ""
    @State private var selectedCategory = "None"
    @State private var currentCount = 0
    @State private var maxCharacters = 500
    @State private var date = Date()
    @State private var showMailView = false
    @State private var noEmailAlert = false
    
    let categories = ["Book", "Log", "Search", "Settings", "Statistics", "Collection", "None"].sorted()
    
    var getDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var getTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Support Category")
//                        .font(.headline)
                        .padding(.horizontal, 5)
                    
                    VStack {
                        HStack {
                            VStack {
                                Text("Category")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 3)
                            
                            VStack {
                                Picker("", selection: $selectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(.gray.opacity(0.10))
                                .padding(.vertical, -5)
                                .padding(.horizontal, -10)
                        )
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                
                Spacer()
                    .frame(height: 50)
                
                VStack(alignment: .leading) {
                    Text("Description")
//                        .font(.headline)
                        .padding(.horizontal, 5)
                    
                    VStack(alignment: .leading) {
                        TextField("Enter description...", text: $descriptionText, axis: .vertical)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(.gray.opacity(0.10))
                                    .frame(width: 375)
                                    .padding(.vertical, -10)
                                    .padding(.horizontal, -10)
                            )
                            .tint(.black)
                            .foregroundStyle(.gray)
                            .lineLimit(6, reservesSpace: true)
                            .onSubmit {
                                date = .now
                            }
                            .onChange(of: descriptionText) {
                                currentCount = descriptionText.count
                            }
                            .focused($focus)
                    }
                    .padding(.vertical, 5)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    VStack {
                        Text("\(currentCount)/\(maxCharacters)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                
                Spacer()
                    .frame(height: 30)
                
                VStack {
                    Button(action: {
                        print("Submitted!")
                        
                        if MailComposer.isAvaliable() {
                            showMailView.toggle()
                        } else {
                            noEmailAlert.toggle()
                        }
                        
                    }) {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(.gray.opacity(0.10))
                            .frame(width: 375, height: 40)
                            .overlay {
                                VStack {
                                    Text("Submit Ticket")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 17)
                            }
                    }
                    .disabled(descriptionText.count == 0 && selectedCategory == "None")
                    
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 25)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Support Ticket")
                        .foregroundStyle(.accent)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Text("Cancel")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .onTapGesture {
                focus = false
            }
            .sheet(isPresented: $showMailView) {
                MailComposer(category: selectedCategory, description: descriptionText, dateCreated: getDate, timeCreated: getTime)
            }
            .alert("No Email Account", isPresented: $noEmailAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("Please configure an email account on your device to send support tickets.")
            }
        }
    }
}

#Preview {
    HelpAndSupportView()
}
