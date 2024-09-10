//
//  SettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext

    @State private var deletedBooksAlert = false
    @State private var activateNotificationsBool = false
    
    var books: [Book]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    let allBooks = Library(books: books)
                    
                    var getCount: Int {
                        var count = 0
                        
                        for _ in allBooks.getCompletedOnly {
                            count += 1
                        }
                        
                        return count
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
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 30.0)
                            .stroke(.black.opacity(0.10), lineWidth: 1.0)
                            .fill(.black.opacity(0.05))
                            .frame(width: 300, height: 150)
                            .shadow(radius: 10)
                            .overlay {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 23))
                                    .offset(x: -100, y: -45)
                            }
                        
                        Text("Books Read: \(getCount)")
                            .font(.system(size: 16))
                            .offset(x: 35, y: -100)
                        Text("In Progress: \(getIPOnly)")
                            .font(.system(size: 14))
                            .offset(x: 35, y: -95)
                        
                        Text("Completed: \(getCOnly)")
                            .font(.system(size: 14))
                            .offset(x: 35, y: -90)
                        
                    }
                    .offset(y: 40)
                    
                    VStack(alignment: .leading) {
                        
                        Rectangle()
                            .fill(.gray.opacity(0.09))
                            .frame(width: 400, height: 600)
                            .overlay {
                                Text("Delete All Books")
                                    .font(.system(size: 14))
                                    .offset(x: -120, y: -270)
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.white)
                                    .frame(width: 350, height: 35)
                                    .offset(x: 2, y: -235)
                                
                                Text("Notifications")
                                    .font(.system(size: 14))
                                    .offset(x: -130, y: -195)
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.white)
                                    .frame(width: 350, height: 35)
                                    .offset(x: 3, y: -160)
                            }
                        
                        Button(action: {
                            deleteAllBooks()
                        }) {
                            Text("Delete")
                                .foregroundStyle(.red)
                        }
                        .offset(x: 37, y: -551)
                        
                        HStack {
                            Text("Enable Notifications")
                                .offset(x: 37, y: -529)
                            
                            Toggle("", isOn: $activateNotificationsBool)
                                .tint(.green)
                                .frame(width: 200)
                                .offset(x: -7, y: -529)
                                .padding()
                        }
                        
                    }
                    .offset(y: 30)
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: activateNotificationsBool) {
                    if activateNotificationsBool {
                        userNotifications()
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
    
    func userNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications enabled.")
                
                let content = UNMutableNotificationContent()
                content.title = "Have you read today?"
                content.body = "Make sure to log your book!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            } else if let error {
                print(error.localizedDescription)
            } else {
                print("Check if there is an error.")
            }
        }
    }
}

#Preview {
    SettingsView(books: [Book]())
}
