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
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
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
                                                        .accessibilityLabel("Edit profile picture")
                                                        .accessibilityAddTraits(.isButton)
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
                                                        .accessibilityAddTraits(.isButton)
                                                        .accessibilityLabel("Edit profile picture")
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
                                        .accessibilityLabel("Enter profile name")
                                } else {
                                    Text(profileName)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Button(action: {
                                        isEditingName.toggle()
                                    }) {
                                        Image(systemName: "pencil")
                                            .accessibilityLabel("Edit name")
                                            .accessibilityAddTraits(.isButton)
                                    }
                                }
                            }
                            
                            Spacer()
                                .frame(height: 30)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.30))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .padding()
                            
                            // Sections
                            VStack(alignment: .leading) {
                                
                                Spacer()
                                    .frame(height: 35)
                                
                                HStack {
                                    Image(systemName: "gearshape")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("Settings")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                    
                                    
                                    VStack {
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        CustomArrowView()
                                    }
                                    .frame(maxWidth: geometry.size.width, alignment: .trailing)
                                    .accessibilityAddTraits(.isButton)
                                    .onTapGesture {
                                        showSettings.toggle()
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 55)
                                
                                
                                HStack {
                                    Image(systemName: "chart.bar.xaxis")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("Statistics")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                    
                                    VStack {
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        CustomArrowView()
                                    }
                                    .frame(maxWidth: geometry.size.width, alignment: .trailing)
                                    .accessibilityAddTraits(.isButton)
                                    .onTapGesture {
                                        showStatistics.toggle()
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 55)
                                
                                HStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("Notifications")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .lineLimit(1)
                                    
                                    VStack {
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        CustomArrowView()
                                    }
                                    .frame(maxWidth: geometry.size.width, alignment: .trailing)
                                    .accessibilityAddTraits(.isButton)
                                    .onTapGesture {
                                        showNotifications.toggle()
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 35)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                            
                            Rectangle()
                                .fill(.gray.opacity(0.30))
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .padding()
                            
                            VStack(alignment: .leading) {
                                
                                Spacer()
                                    .frame(height: 35)
                                
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    
                                    Text("Help & Support")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                        .padding(.horizontal)
                                        .fixedSize(horizontal: true, vertical: false)
                                    
                                    VStack {
                                        Spacer()
                                            .frame(height: 8)
                                        
                                        CustomArrowView()
                                    }
                                    .frame(maxWidth: geometry.size.width, alignment: .trailing)
                                    .accessibilityAddTraits(.isButton)
                                    .onTapGesture {
                                        showSupport.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            .padding(.bottom, 50)
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
