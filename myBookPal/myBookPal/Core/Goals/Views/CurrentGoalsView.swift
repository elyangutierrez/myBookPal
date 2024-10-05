//
//  CurrentGoalsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import SwiftUI
import SwiftData

struct CurrentGoalsView: View {
    
    @State private var goalManager: GoalManager
    @State private var goalToDelete: Goal?
    @State private var dateManager = DateManager()
    @State private var showAddGoalSheet = false
    @State private var goalAdded: Bool = false
    @State private var today = Date.now
    @State private var hapticManager = HapticsManager()
    
    private func callManagerMethods() {
        dateManager.getWeekDayNames()
        dateManager.getWeekDayNumbers()
        dateManager.getCurrentDay()
        dateManager.getCurrentMonth()
        dateManager.setSelectedDay()
    }
    
    var body: some View {
        NavigationStack {
            
            Spacer()
                .frame(height: 10)
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        VStack {
                            // current month text
                            Text(dateManager.currentMonth)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 25)
                        
                        VStack {
                            // days
                            HStack {
                                VStack {
                                    // 1
                                    
                                    Text(dateManager.dayNameOne)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberOne ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberOne)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberOne ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberOne {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 50)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 2
                                    
                                    Text(dateManager.dayNameTwo)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberTwo ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberTwo)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberTwo ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberTwo {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 3
                                    
                                    Text(dateManager.dayNameThree)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberThree ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberThree)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberThree ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberThree {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 4
                                    
                                    Text(dateManager.dayNameFour)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberFour ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberFour)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberFour ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberFour {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 5
                                    
                                    Text(dateManager.dayNameFive)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberFive ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberFive)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberFive ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberFive {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 6
                                    
                                    Text(dateManager.dayNameSix)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberSix ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberSix)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberSix ? .white : .black)
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberSix {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack {
                                    // 7
                                    
                                    Text(dateManager.dayNameSeven)
                                        .font(.footnote)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberSeven ? .white : .weekName)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text(dateManager.dayNumberSeven)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(dateManager.currentDay == dateManager.dayNumberSeven ? .white : .black)
                                    
                                    
                                }
                                .background {
                                    if dateManager.currentDay == dateManager.dayNumberSeven {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.complement.opacity(0.70))
                                            .frame(width: 35, height: 60)
                                            .shadow(color: .complement, radius: 5)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        //                    .padding(.horizontal, 68)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        VStack {
                            // add goal card
                            
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(.gray.opacity(0.15))
                                .frame(width: 300, height: 115)
                                .overlay {
                                    VStack {
                                        VStack(alignment: .leading) {
                                            Text("Want to add a goal?")
                                                .font(.system(size: 13, weight: .bold))
                                                .accessibilityLabel("Want to add a goal?")
                                            
                                            Spacer()
                                                .frame(height: 5)
                                            
                                            Text("Click the button to get started!")
                                                .font(.system(size: 12))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                        
                                        Spacer()
                                            .frame(height: 15)
                                        
                                        Button(action: {
                                            showAddGoalSheet.toggle()
                                        }) {
                                            RoundedRectangle(cornerRadius: 15.0)
                                                .fill(.accent)
                                                .frame(width: 265, height: 30)
                                                .overlay {
                                                    VStack {
                                                        Image(systemName: "plus")
                                                            .foregroundStyle(.white)
                                                            .fontWeight(.bold)
                                                    }
                                                }
                                                .shadow(radius: 5)
                                                .accessibilityHint("Touch to add goal")
                                        }
                                    }
                                }
                                .allowsHitTesting(true)
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        

                        if !goalManager.goals.isEmpty {
                            
                            VStack {
                                // current goals text
                                Text("Current Goals")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            
                            
                            VStack {
                                ForEach(goalManager.goals, id: \.self) { goal in
                                    VStack {
                                        
                                        // date goal was created on
                                        
                                        VStack {
                                            Text(goal.createdOnString)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.gray.opacity(0.75))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 20)
                                        
                                        HStack {
                                            VStack {
                                                // time
                                                
                                                Text(goal.timeCreated)
                                                    .font(.caption2)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(.weekName)
                                                
                                                // vertical line
                                                
                                                Rectangle()
                                                    .foregroundStyle(.weekName)
                                                    .frame(width: 1.50, height: 150)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 21)
                                            
                                            VStack {
                                                VStack {
                                                    RoundedRectangle(cornerRadius: 15.0)
                                                        .fill(goal.selectedNumber == 1 ? .complement.opacity(0.50) : .darkerComplement)
                                                        .frame(width: geometry.size.width * 0.67, height: 150)
                                                        .overlay {
                                                            VStack {
                                                                VStack(alignment: .leading) {
                                                                    HStack {
                                                                        VStack {
                                                                            RoundedRectangle(cornerRadius: 5.0)
                                                                                .fill(.white)
                                                                                .frame(width: 50, height: 25)
                                                                                .overlay {
                                                                                    VStack {
                                                                                        Text(goal.priority)
                                                                                            .font(.caption2)
                                                                                    }
                                                                                }
                                                                        }
                                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                                        
                                                                        VStack {
                                                                            Menu {
                                                                                Button("Delete", role: .destructive, action: {
                                                                                    goalToDelete = goal
                                                                                    deleteGoal()
                                                                                }
                                                                                )
                                                                                
                                                                            } label: {
                                                                                Circle()
                                                                                    .fill(.clear)
                                                                                    .frame(width: 30, height: 30)
                                                                                    .overlay {
                                                                                        Image(systemName: "ellipsis")
                                                                                            .foregroundStyle(.white)
                                                                                            .fontWeight(.bold)
                                                                                    }
                                                                                    .accessibilityLabel("Tap to edit goal")
                                                                            }
                                                                        }
                                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                                    }
                                                                    
                                                                    Spacer()
                                                                        .frame(height: 15)
                                                                    
                                                                    Text(goal.text)
                                                                        .fontWeight(.bold)
                                                                        .foregroundStyle(.white)
                                                                        .accessibilityLabel("Goal: \(goal.text)")
                                                                    
                                                                    Spacer()
                                                                        .frame(height: 15)
                                                                    
                                                                    HStack {
                                                                        Image(systemName: "calendar")
                                                                            .foregroundStyle(.white)
                                                                            .fontWeight(.bold)
                                                                        
                                                                        Spacer()
                                                                            .frame(width: 5)
                                                                        
                                                                        HStack {
                                                                            Text("Deadline:")
                                                                                .font(.footnote)
                                                                                .fontWeight(.bold)
                                                                                .foregroundStyle(.white)
                                                                            
                                                                            Text("\(goal.getDeadline)")
                                                                                .font(.footnote)
                                                                                .foregroundStyle(.white)
                                                                                .padding(.horizontal, -5)
                                                                        }
                                                                        .accessibilityLabel("Deadline: \(goal.getDeadline)")
                                                                    }
                                                                    
                                                                    Spacer()
                                                                        .frame(height: 20)
                                                                    
                                                                }
                                                                .frame(maxHeight: .infinity, alignment: .top)
                                                                .padding(.vertical, 10)
                                                            }
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.horizontal, 10)
                                                        }
                                                        .shadow(color: goal.selectedNumber == 1 ? .complement.opacity(0.50) : .darkerComplement, radius: 5)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .frame(maxHeight: .infinity, alignment: .top)
                                            
                                            Spacer()
                                                .frame(width: 20)
                                        }
                                        .onAppear {
                                            if goal.deadline < today {
                                                goalManager.removeGoal(goal)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                        .frame(height: 35)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Goals")
                        .fontWeight(.semibold)
                }
 
                // DEBUG:
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: {
//                        goalManager.addGoal()
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
            }
            .onAppear {
                callManagerMethods()
                print(goalManager.goals)
            }
            .sheet(isPresented: $showAddGoalSheet) {
                AddGoalView(goalAdded: $goalAdded)
                    .presentationDetents([.height(675)])
                    .presentationCornerRadius(25.0)
            }
            .onChange(of: goalAdded) {
                goalManager.fetchGoals()
                print("Call the methods on change.")
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let goalManager = GoalManager(modelContext: modelContext)
        _goalManager = State(initialValue: goalManager)
    }
    
    func deleteGoal() {
        
        guard let goal = goalToDelete else {
            print("DEBUG: Failed to delete goal")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.15)) {
                goalManager.removeGoal(goal)
            }
        }
        hapticManager.playRemovedGoal()
    }
}

//#Preview {
//    CurrentGoalsView()
//}
