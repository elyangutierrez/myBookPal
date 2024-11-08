//
//  AddGoalView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import SwiftUI

struct AddGoalView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var goalDescription: String = ""
    @State private var dueDateSelection = Date()
    @State private var isReminderEnabled: Bool = false
    @State private var reminderDate = Date()
    @State private var prioritySelection: String = "Medium"
    @State private var showAddGoalAlert: Bool = false
    @State private var reminderManager = ReminderManager()
    @State private var showAlert = false
    @State private var hapticsManager = HapticsManager()
    
    @Binding var goalAdded: Bool
    
    let selections = ["High", "Medium", "Low"]
    
    var initialDate: TimeInterval {
        let minute = 60
        let hour = 60 * minute
        
        return Double(hour) * 24.0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter description", text: $goalDescription)
                } header: {
                    Text("Goal Description")
                        .accessibilityLabel("Enter goal description")
                } footer: {
                    Text("Keep your goals short and concise for optimal efficiency.")
                        .accessibilityHint("Keeps goal descriptions short and concise for optimal efficiency.")
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $dueDateSelection, in: Date.now.addingTimeInterval(initialDate)...Date.distantFuture)
                        .accessibilityLabel("Select a due date")
                }
                
                Section("Reminder Notification") {
                    Toggle("Enable Reminder", isOn: $isReminderEnabled)
                        .accessibilityLabel("Enable reminder notification")
                        .accessibilityAddTraits(.isToggle)
                    
                    // TODO: When enabled, ask for noti perms, else carry on.
                    
                    if isReminderEnabled {
                        
                        DatePicker("Reminder", selection: $reminderDate, in: Date.now.addingTimeInterval(initialDate)...Date.distantFuture)
                            .accessibilityLabel("Select a reminder date")
                    }
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $prioritySelection) {
                        ForEach(selections, id: \.self) { selection in
                            Text(selection)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Select a priority such as High, Medium, or Low")
                }
                
                Button(action: {
                    showAddGoalAlert.toggle()
                }) {
                    Text("Add Goal")
                        .accessibilityLabel("Add Goal")
                }
                .disabled(goalDescription == "" || dueDateSelection == Date.now)
                .accessibilityAddTraits(.isButton)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Goal")
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                        
                    }) {
                        Text("Cancel")
                    }
                }
            }
            .onChange(of: isReminderEnabled) {
//                let manager = ReminderManager()
                Task {
                    await reminderManager.checkIfNotificationsAreEnabled()
                }
            }
            .alert("Goal Added!", isPresented: $showAddGoalAlert) {
                Button("Ok", role: .cancel, action: {
                    addGoalToList()
                    dismiss()
                })
                // actually add it to the list
            } message: {
                Text("This goal has been added to your list!")
            }
            .alert("Invalid Info", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You")
            }
        }
    }
    
    func addGoalToList() {
        
        let gen = Int.random(in: 1...2)
        
        
        if isReminderEnabled {
            let goal = Goal(text: goalDescription, createdOn: Date.now, deadline: dueDateSelection, status: "In Progress", reminderOn: isReminderEnabled, priority: prioritySelection, selectedNumber: gen)
            reminderManager.goalTitle = goalDescription
            reminderManager.reminderDate = reminderDate
            reminderManager.createNotification()
            modelContext.insert(goal)
            try? modelContext.save()
            hapticsManager.playAddedGoal()
            print("Add goal to list!")
            goalAdded.toggle()
        } else {
            let goal = Goal(text: goalDescription, createdOn: Date.now, deadline: dueDateSelection, status: "In Progress", reminderOn: isReminderEnabled, priority: prioritySelection, selectedNumber: gen)
            modelContext.insert(goal)
            try? modelContext.save()
            hapticsManager.playAddedGoal()
            print("Add goal to list!")
            goalAdded.toggle()
        }
    }
}

#Preview {
    AddGoalView(goalAdded: .constant(true))
}
