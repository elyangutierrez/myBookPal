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
    
    private func callManagerMethods() {
        dateManager.getWeekDayNames()
        dateManager.getWeekDayNumbers()
        dateManager.getCurrentDay()
        dateManager.getCurrentMonth()
        dateManager.setSelectedDay()
    }
    
    var body: some View {
        NavigationStack {
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
                                        .frame(width: 40, height: 50)
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
                                        .frame(width: 40, height: 60)
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
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 68)
                    
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
                                        
                                        Spacer()
                                            .frame(height: 5)
                                        
                                        Text("Click the button to get started!")
                                            .font(.system(size: 12))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 15)
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    NavigationLink(destination: AddGoalView()) {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.black)
                                            .frame(width: 265, height: 30)
                                            .overlay {
                                                Image(systemName: "plus")
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.bold)
                                            }
                                    }
                                }
                            }
                            .allowsHitTesting(true)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    VStack {
                        // current goals text
                        Text("Current Goals")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        // date goal was added
                        
                        HStack {
                            VStack {
                                // time and line
                            }
                            
                            VStack {
                                // goal card
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Goals")
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                callManagerMethods()
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let goalManager = GoalManager(modelContext: modelContext)
        _goalManager = State(initialValue: goalManager)
    }
}

//#Preview {
//    CurrentGoalsView()
//}
