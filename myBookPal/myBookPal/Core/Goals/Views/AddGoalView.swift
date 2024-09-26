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
    @State private var pagesWantToRead: Int? = nil
    @State private var reminderManager = ReminderManager()
    @Binding var goalAdded: Bool
    
    let selections = ["High", "Medium", "Low"]
    
//    var getInterval: TimeInterval {
//        let minute = 60
//        let hour = 60 * minute
//        let day = 24 * hour
//        
//        switch prioritySelection {
//        case "High":
//            return Double(day) * 1.0
//        case "Medium":
//            return Double(day) * 2.0
//        case "Low":
//            return Double(day) * 3.0
//        default:
//            return Double(day)
//        }
//    }
    
    var initialDate: TimeInterval {
        let minute = 60
        let hour = 60 * minute
        
        return Double(hour) * 24.0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Description") {
                    // enter goal description
                    TextField("Enter description", text: $goalDescription)
                }
                
                Section("Page Target (Optional)") {
                    TextField("Enter Target", value: $pagesWantToRead, format: .number)
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $dueDateSelection, in: Date.now...Date.distantFuture)
                }
                
                Section("Reminder Notification") {
                    Toggle("Enable Reminder", isOn: $isReminderEnabled)
                    
                    // TODO: When enabled, ask for noti perms, else carry on.
                    
                    if isReminderEnabled {
                        
                        DatePicker("Reminder", selection: $reminderDate, in: Date.now...Date.distantFuture)
                    }
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $prioritySelection) {
                        ForEach(selections, id: \.self) { selection in
                            Text(selection)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.white)
                    .frame(width: 375, height: 30)
                    .overlay {
                        VStack {
                            Text("Add Goal")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    .onTapGesture {
                        showAddGoalAlert.toggle()
                    }
                    .disabled(goalDescription == "" || dueDateSelection == Date.now)
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
                Button("Ok", role: .cancel, action: addGoalToList)
                // actually add it to the list
            } message: {
                Text("This goal has been added to your list!")
            }
        }
    }
    
    func addGoalToList() {
        
        let gen = Int.random(in: 1...2)
        
        
        if isReminderEnabled {
            let goal = Goal(text: goalDescription, createdOn: Date.now, deadline: dueDateSelection, target: Double(pagesWantToRead ?? 0), status: "In Progress", reminderOn: isReminderEnabled, priority: prioritySelection, selectedNumber: gen)
            reminderManager.goalTitle = goalDescription
            reminderManager.reminderDate = reminderDate
            reminderManager.createNotification()
            modelContext.insert(goal)
            try? modelContext.save()
            print("Add goal to list!")
            goalAdded.toggle()
        } else {
            let goal = Goal(text: goalDescription, createdOn: Date.now, deadline: dueDateSelection, target: Double(pagesWantToRead ?? 0), status: "In Progress", reminderOn: isReminderEnabled, priority: prioritySelection, selectedNumber: gen)
            modelContext.insert(goal)
            try? modelContext.save()
            print("Add goal to list!")
            goalAdded.toggle()
        }
    }
}

#Preview {
    AddGoalView(goalAdded: .constant(true))
}
