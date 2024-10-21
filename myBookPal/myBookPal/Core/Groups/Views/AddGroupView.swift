//
//  AddGroupView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/20/24.
//

import SwiftUI
import PhotosUI

struct AddGroupView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var groupTitle = ""
    @State private var pictureHandler = PictureHandler()
    @State private var showCameraPicker = false
    var groupManager: GroupManager
    
    var body: some View {
        NavigationStack {
            GeometryReader { g in
                VStack {
                    VStack {
                        if pictureHandler.displayedImage != nil {
                            Menu {
                                Button(action: {
                                    showCameraPicker.toggle()
                                }) {
                                    Text("Take Picture")
                                }
                                
                                Button(action: {
                                    pictureHandler.showPhotosPicker.toggle()
                                }) {
                                    Text("Select from Gallery")
                                }
                            } label: {
                                pictureHandler.displayedImage?
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                    .frame(width: 200, height: 200)
                                    .scaledToFit()
                                    .overlay {
                                        Circle()
                                            .fill(.complement)
                                            .frame(width: 70, height: 70)
                                            .overlay {
                                                Image(systemName: "camera.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 30)
                                                    .foregroundStyle(.white)
                                            }
                                    }
                            }
                        } else {
                            Menu {
                                Button(action: {
                                    showCameraPicker.toggle()
                                }) {
                                    Text("Take Picture")
                                }
                                
                                Button(action: {
                                    pictureHandler.showPhotosPicker.toggle()
                                }) {
                                    Text("Select from Gallery")
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(.gray)
                                    .frame(width: 200, height: 200)
                                    .overlay {
                                        Circle()
                                            .fill(.complement)
                                            .frame(width: 70, height: 70)
                                            .overlay {
                                                Image(systemName: "camera.fill")
                                                    .resizable()
                                                    .frame(width: 40, height: 30)
                                                    .foregroundStyle(.white)
                                            }
                                    }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 50)
                        
                        VStack(alignment: .center) {
                            TextField("Group Title", text: $groupTitle)
//                                .fixedSize(horizontal: true, vertical: false)
                                .frame(width: 300, height: 40, alignment: .center)
                                .multilineTextAlignment(.center)
                        }
                        .frame(alignment: .center)
                        
                        Rectangle()
                            .fill(.gray.opacity(0.30))
                            .frame(maxWidth: g.size.width, maxHeight: 1)
                            .padding(.horizontal, 15)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.vertical, 25)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .photosPicker(isPresented: $pictureHandler.showPhotosPicker, selection: $pictureHandler.pickerItem, matching: .images)
            .onChange(of: pictureHandler.pickerItem) {
                Task {
                    await pictureHandler.convertPickerItemToImage()
                    
                    guard let image = pictureHandler.selectedImage else { return }
                    
                    pictureHandler.imageData = pictureHandler.convertImageToData(image: image)
                    print("resulting of converting to data: \(pictureHandler.imageData!)")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("Tapped button!")
                        if pictureHandler.displayedImage == nil {
                            let group = Group(name: groupTitle, creationDate: Date.now, imageData: nil)
                            groupManager.addGroup(group)
                            dismiss()
                        } else {
                            guard let image = pictureHandler.selectedImage else { return }
                            pictureHandler.imageData = pictureHandler.convertImageToData(image: image)
                            let group = Group(name: groupTitle, creationDate: Date.now, imageData: pictureHandler.imageData!)
                            groupManager.addGroup(group)
                            dismiss()
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(groupTitle.isEmpty)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Create Group")
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: {
                        dismiss()
                    })
                }
            }
            .sheet(isPresented: $showCameraPicker) {
                CameraPickerView { image in
                    pictureHandler.convertUIImageToImage(image: image)
                }
                .ignoresSafeArea()
            }
        }
    }
}

//#Preview {
//    AddGroupView(groupManager: GroupManager(modelContext: <#T##ModelContext#>))
//}
