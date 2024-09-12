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
    @State private var activateNotificationsBool = false
    @State var notificationsModel = NotificationsModel()
    
    @AppStorage("isNotificationsActive") var isNotificationsActive: Bool = false
    
    var totalBooksCount = 4
    var inProgressCount = 2
    var completed = 2
    
    var books: [Book]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    Color.white
                        .frame(height: 275)
                    
                    let allBooks = Library(books: books)
                    
                    var getCount: Int {
                        return allBooks.getTotalBookCount
                    }
                    
                    var getIPOnly: Int {
                        var count = 0
                        
                        if allBooks.getInProgressOnly == [] {
                            return 0
                        } else {
                            for _ in allBooks.getInProgressOnly {
                                count += 1
                            }
                        }
                        
                        return count
                    }
                    
                    var getCOnly: Int {
                        var count = 0
                        
                        if allBooks.getCompletedOnly == [] {
                            return 0
                        } else {
                            for _ in allBooks.getCompletedOnly {
                                count += 1
                            }
                        }
                        
                        return count
                    }
                    
                    if getIPOnly == 0 {
                        Text("No Statistics Avaliable...")
                            .foregroundStyle(.gray)
                            .font(.headline)
                    } else {
                        DonutChartView(totalBooksCount: getCount, booksRead: getCOnly, booksInProgress: getIPOnly)
                    }
                }
                ZStack {
                    Color.gray.opacity(0.10)
                        .frame(height: 500)
                    VStack {
                        
                        VStack(alignment: .leading) {
                            Section("Delete All Books") {
                                Capsule()
                                    .fill(.white)
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
                            }
                            
                            Section("Notifications") {
                                Capsule()
                                    .fill(.white)
                                    .frame(width: 350, height: 35)
                                    .overlay {
                                        Toggle("Enable Notifications", isOn: $isNotificationsActive)
                                            .padding(.horizontal, 15)
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 25)
                    }
                }
                .navigationTitle("More")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: isNotificationsActive) {
                    if isNotificationsActive {
                        notificationsModel.userNotifications()
                    } else {
                        print("User notifications are off.")
                    }
                }
                .alert(isPresented: $deletedBooksAlert) {
                    Alert(title: Text("Are you sure you want to delete all books?"),
                          message: Text("Once deleted, you can't get your books and logs back."),
                          primaryButton: .destructive(Text("Delete")) {
                        deleteBooks()
                    },
                          secondaryButton: .cancel())
                    
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
            // TODO: Show alert if failed.
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
