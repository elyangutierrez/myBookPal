//
//  SettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import Charts
import SwiftUI
import UserNotifications
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    
    @AppStorage("isNotificationsOn") private var isNotificationsOn = false

    @State private var deletedBooksAlert = false
    @State private var activateNotificationsBool = false
    @State var notificationsModel = NotificationsModel()
    @State private var notificationsText = ""
    
    var books: [Book]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Delete", role: .destructive,
                           action: {
                        deletedBooksAlert.toggle()
                    })
                } header: {
                    Text("Delete All Books")
                } footer: {
                    Text("Please note that this will delete all your books and logs. You can't get them back. Do at your own discretion.")
                }
                
                Section("Enable Notifications") {
                    Toggle(notificationsText, isOn: $isNotificationsOn)
                        .accessibilityLabel("Enable Notifications: \(isNotificationsOn ? "On" : "Off")")
                        .accessibilityAddTraits(.isToggle)
                        .onChange(of: isNotificationsOn) {
                            if isNotificationsOn == true {
                                notificationsText = "Enabled"
                                notificationsModel.enableNotifications()
                                Task {
                                    await notificationsModel.sendDailyNotifications()
                                }
                            } else {
                                notificationsText = "Enable"
                                notificationsModel.cancelDailyNotifications()
                            }
                        }
                        .onAppear {
                            if isNotificationsOn {
                                notificationsText = "Enabled"
                            } else {
                                notificationsText = "Enable"
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $deletedBooksAlert) {
                Alert(title: Text("Are you sure you want to delete all books?").accessibilityLabel("Are you sure you want to delete all books?"),
                      message: Text("Once deleted, you can't get your books and logs back."),
                      primaryButton: .destructive(Text("Delete").accessibilityLabel("Delete")) {
                    deleteBooks(context: modelContext)
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
    
    func deleteAllBooks() {
        deletedBooksAlert = true
    }
    
    func deleteBooks(context: ModelContext) {
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