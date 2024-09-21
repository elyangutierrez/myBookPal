//
//  SettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import Charts
import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext

    @State private var deletedBooksAlert = false
    
    var books: [Book]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    VStack {
                        VStack(alignment: .leading) {
                            Section("Delete All Books") {
                                Capsule()
                                    .fill(.gray.opacity(0.10))
                                    .frame(width: 350, height: 30)
                                    .overlay {
                                        VStack {
                                            Button(action: {
                                                deleteAllBooks()
                                            }) {
                                                Text("Delete")
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 25)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $deletedBooksAlert) {
                    Alert(title: Text("Are you sure you want to delete all books?"),
                          message: Text("Once deleted, you can't get your books and logs back."),
                          primaryButton: .destructive(Text("Delete")) {
                        deleteBooks()
                    },
                          secondaryButton: .cancel())
                    
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
    
    func deleteAllBooks() {
        deletedBooksAlert = true
    }
    
    func deleteBooks() {
        do {
            try modelContext.delete(model: Book.self)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func resetAlert() {
        deletedBooksAlert = false
    }
}

#Preview {
    SettingsView(books: [Book]())
}
