//
//  TipSheetView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/11/24.
//

import SwiftUI
import StoreKit

struct TipSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var store = StoreKitManager()
    @Binding var isPresented: Bool
    @Binding var tipPurchased: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                //                Spacer()
                //                    .frame(height: 150)
                //
                VStack {
                    Image(.appLogo)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Tip the Developer")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(alignment: .leading) {
                        Text("Hello! Since this app this free to use, I would like to thank you for using it. If you enjoy it, please consider tipping me a small amount as it will go to keep this app running!")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    HStack {
                        ForEach(store.items) { item in
                            
                            Button(action: {
                                Task {
                                    await store.purchase(item)
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.complement)
                                    .frame(width: 80, height: 40)
                                    .overlay {
                                        Text("\(item.displayName)")
                                            .foregroundStyle(.white)
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                            }
                            
                        }
                    }
                }
                .frame(maxHeight: geometry.size.height)
            }
            .onChange(of: store.action) {
                if store.action == .successful {
                    store.reset()
                    
                    isPresented.toggle()
                    tipPurchased.toggle()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    TipSheetView(isPresented: .constant(true), tipPurchased: .constant(true))
}
