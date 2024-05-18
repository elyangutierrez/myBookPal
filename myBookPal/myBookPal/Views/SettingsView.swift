//
//  SettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var deletedBooksAlert = false
    @Binding var setBookTotal: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Set Book Goal") {
                    TextField("Enter Goal", value: $setBookTotal, format: .number)
                }
                Button(action: {
                    deleteAllBooks()
                }) {
                    Text("Delete All Books")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Exit")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .alert(isPresented: $deletedBooksAlert) {
            Alert(title: Text("Are you sure you want to delete all books?"), message: Text("Once deleted, you can't get your books and logs back."), primaryButton: .destructive(Text("Delete")), secondaryButton: .cancel())
        }
    }
    
    func deleteAllBooks() {
        do {
            try modelContext.delete(model: Book.self)
            deletedBooksAlert = true
        } catch {
            print("Failed to delete books")
        }
    }
    
    func resetAlert() {
        deletedBooksAlert = false
    }
}

#Preview {
    SettingsView(setBookTotal: .constant(15))
}
