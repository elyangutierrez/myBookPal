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
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Reset to Factory Settings") {
                    Button(action: {
                        deleteAllBooks()
                    }) {
                        Text("Delete All Books")
                            .foregroundStyle(.red)
                    }
                }
                
                Section("Notifications") {
//                    Button(action: {
//                        userNotifications()
//                    }) {
//                        Text("Enable Notifications")
//                    }
                    Toggle("Enable Notifications", isOn: $activateNotificationsBool)
                        .tint(.green)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: activateNotificationsBool) {
                if activateNotificationsBool {
                    userNotifications()
                } else {
                    print("User notifications are off")
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
    
    func userNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications enabled.")
                
                let content = UNMutableNotificationContent()
                content.title = "Have you read today?"
//                content.subtitle = "Make sure to log your daily reading!"
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
    SettingsView()
}
