//
//  ProfileView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import PhotosUI
import SwiftData
import SwiftUI

struct ProfileView: View {
    
    @State private var pictureHandler = PictureHandler()
    @State private var isEditingName: Bool = false
    @State private var showSettings = false
    @State private var showStatistics = false
    @State private var showNotifications = false
    @State private var showSupport = false
    @State private var didAppear = false
    @AppStorage("profileName") var profileName: String = "Enter profile name"
    @AppStorage("imageUUID") var imageUUID: String = ""
    
    var books: [Book]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                VStack {
                    Spacer()
                        .frame(height: 15)
                    
                    if pictureHandler.displayedImage == nil {
                        Circle()
                            .fill(.gray.opacity(0.40))
                            .frame(width: 135, height: 135)
                            .shadow(radius: 10)
                            .overlay {
                                
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .fill(.clear)
                                    .frame(width: 144, height: 144)
                                
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 100)
                                    
                                    Circle()
                                        .fill(.accent)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            Image(systemName: "plus")
                                                .foregroundStyle(.white)
                                        }
                                        .onTapGesture {
                                            pictureHandler.showPhotosPicker.toggle()
                                        }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, 5)
                                .photosPicker(isPresented: $pictureHandler.showPhotosPicker, selection: $pictureHandler.pickerItem, matching: .any(of: [.images, .not(.screenshots)]))
                            }
                            .allowsHitTesting(true)
                    } else {
                        pictureHandler.displayedImage?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 135, height: 135)
                            .flipsForRightToLeftLayoutDirection(false)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay {
                                
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .fill(.clear)
                                    .frame(width: 144, height: 144)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 100)
                                    
                                    Circle()
                                        .fill(.accent)
                                        .frame(width: 30, height: 30)
                                        .overlay {
                                            Image(systemName: "plus")
                                                .foregroundStyle(.white)
                                        }
                                        .onTapGesture {
                                            pictureHandler.showPhotosPicker.toggle()
                                        }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, 5)
                                .photosPicker(isPresented: $pictureHandler.showPhotosPicker, selection: $pictureHandler.pickerItem, matching: .images)
                            }
                            .allowsHitTesting(true)
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack {
                        if isEditingName {
                            TextField("Enter profile name", text: $profileName)
                                .font(.title2)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    isEditingName = false
                                }
                                .padding(.horizontal, 135)
                        } else {
                            Text(profileName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Button(action: {
                                isEditingName.toggle()
                            }) {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 40)
                    
                    Rectangle()
                        .frame(width: 375, height: 2)
                        .foregroundStyle(.gray.opacity(0.40))
                    
                    // Sections
                    VStack(alignment: .leading) {
                        
                        Spacer()
                            .frame(height: 35)
                        
                        VStack {
                            HStack {
                                VStack {
                                    Image(systemName: "gearshape")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Spacer()
                                    .frame(width: 20)
                                
                                VStack {
                                    Text("Settings")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                    .frame(width: 200)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    CustomArrowView()
                                }
                            }
                        }
                        .onTapGesture {
                            showSettings.toggle()
                        }
                        
                        Spacer()
                            .frame(height: 55)
                        
                        VStack {
                            HStack {
                                VStack {
                                    Image(systemName: "chart.bar.xaxis")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Spacer()
                                    .frame(width: 20)
                                
                                VStack {
                                    Text("Statistics")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                    .frame(width: 190)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    CustomArrowView()
                                }
                            }
                        }
                        .onTapGesture {
                            showStatistics.toggle()
                        }
                        
                        Spacer()
                            .frame(height: 55)
                        
                        VStack {
                            HStack {
                                VStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Spacer()
                                    .frame(width: 20)
                                
                                VStack {
                                    Text("Notifications")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                    .frame(width: 157)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    CustomArrowView()
                                }
                            }
                        }
                        .onTapGesture {
                            showNotifications.toggle()
                        }
                        
                        Spacer()
                            .frame(height: 35)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 35)
                    
                    Rectangle()
                        .frame(width: 375, height: 2)
                        .foregroundStyle(.gray.opacity(0.40))
                    
                    VStack(alignment: .leading) {
                        
                        Spacer()
                            .frame(height: 35)
                       
                        VStack {
                            HStack {
                                VStack {
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Spacer()
                                    .frame(width: 20)
                                
                                VStack {
                                    Text("Help & Support")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                    .frame(width: 135)
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 8)
                                    
                                    CustomArrowView()
                                }
                            }
                        }
                        .onTapGesture {
                            showSupport.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 35)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
            }
            .onChange(of: pictureHandler.pickerItem) {
                Task {
                    await pictureHandler.convertPickerItemToImage()
                    
                    guard let image = pictureHandler.selectedImage else {
                        print("asdfasdfasdf")
                        return
                    }
                    
                    
                    imageUUID = pictureHandler.saveImage(image: image)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(books: books)
                    .presentationDetents([.height(550)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25.0)
            }
            .sheet(isPresented: $showStatistics) {
                StatisticsView(books: books)
                    .presentationDetents([.height(550)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25.0)
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
                    .presentationDetents([.height(550)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25.0)
            }
            .fullScreenCover(isPresented: $showSupport) {
                HelpAndSupportView()
            }
        }
        .onAppear {
            if imageUUID == "" {
                print("On Appear failed.")
                return
            } else {
                pictureHandler.selectedImage = pictureHandler.loadImage(uuid: imageUUID)
                
                pictureHandler.displayedImage = Image(uiImage: pictureHandler.selectedImage!)
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
