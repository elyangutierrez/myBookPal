//
//  NotificationsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("isNotificationsOn") private var isNotificationsOn = false
    @State private var activateNotificationsBool = false
    @State var notificationsModel = NotificationsModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                ZStack {
//                    Color.gray.opacity(0.10)
//                        .frame(height: 500)
                    VStack {
                        VStack(alignment: .leading) {
                            Section("Notifications") {
                                Capsule()
                                    .fill(.gray.opacity(0.10))
                                    .frame(width: 350, height: 35)
                                    .overlay {
                                        Toggle("Enable Notifications", isOn: $isNotificationsOn)
                                            .accessibilityLabel("Enable Notifications: \(isNotificationsOn ? "On" : "Off")")
                                            .accessibilityAddTraits(.isToggle)
                                            .padding(.horizontal, 15)
                                            .onChange(of: isNotificationsOn) {
                                                if isNotificationsOn == true {
                                                    notificationsModel.enableNotifications()
                                                    Task {
                                                        await notificationsModel.sendDailyNotifications()
                                                    }
                                                } else {
                                                    notificationsModel.cancelDailyNotifications()
                                                }
                                            }
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
                .onAppear {
                    print(isNotificationsOn)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Notifications")
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
