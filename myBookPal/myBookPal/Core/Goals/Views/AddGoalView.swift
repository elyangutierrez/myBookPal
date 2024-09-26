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
    @State private var prioritySelection: String = "Medium"
    @State private var showAddGoalAlert: Bool = false
    @State private var pagesWantToRead: Int? = nil
    @Binding var goalAdded: Bool
    
    let selections = ["High", "Medium", "Low"]
    
    var interval: DateInterval {
        let i = DateInterval(start: Date.now, end: dueDateSelection)
        return i
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Description") {
                    // enter goal description
                    TextField("Enter description", text: $goalDescription)
                }
                
                Section("Page Target (Optional") {
                    TextField("Enter Target", value: $pagesWantToRead, format: .number)
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $dueDateSelection)
                }
                
                Section("Reminder Notification") {
                    Toggle("Enable Reminder", isOn: $isReminderEnabled)
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
        
        let goal = Goal(text: goalDescription, createdOn: Date.now, timeFrame: interval, deadline: dueDateSelection, target: Double(pagesWantToRead ?? 0), status: "In Progress", reminderOn: isReminderEnabled, priority: prioritySelection, selectedNumber: gen)
        modelContext.insert(goal)
        try? modelContext.save()
        print("Add goal to list!")
        goalAdded.toggle()
    }
}

#Preview {
    AddGoalView(goalAdded: .constant(true))
}
