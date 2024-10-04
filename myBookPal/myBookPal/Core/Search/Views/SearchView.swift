//
//  SearchView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftUI

struct SearchView: View {
    @State var fetchBookInfoViewModel = FetchBookInfoViewModel()
    @State private var currentBook: VolumeInfo?
    @State private var addViewBook: VolumeInfo? = nil
    
    @Binding var isShowingSheet: Bool
    
    var collectionBooks: [Book]
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 165), spacing: -15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(height: 30)
                LazyVGrid(columns: adaptiveColumn, spacing: 10) {
                    ForEach(fetchBookInfoViewModel.books, id: \.self) { book in
                        
                        // TODO: Instead of using navigationDestination, try navigationLink?
                        
                        NavigationLink {
                            AddView(showingSheet: $isShowingSheet, bookItem: $addViewBook, book: book, books: collectionBooks)
                                .accessibilityAddTraits(.isButton)
                        } label: {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 165, height: 350)
                                .overlay {
                                    VStack {
                                        AsyncImage(url: URL(string: book.imageLinks?.secureThumbnailURL ?? "")) { phase in
                                            switch phase {
                                            case .empty:
                                                VStack {
                                                    ProgressView()
                                                    
                                                    Spacer()
                                                        .frame(height: 70)
                                                }
                                            case .success(let image):
                                                image
                                                    .SearchImageBookExtension()
                                                    .accessibilityHint("Image of \(book.title)")
                                            case .failure(let error):
                                                Color.red
                                                let _ = print(error)
                                            @unknown default:
                                                fatalError()
                                            }
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Spacer()
                                            .frame(height: 210)
                                        Text(book.title)
                                            .font(.system(size: 13))
                                            .fontWeight(.bold)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .accessibilityLabel("\(book.title)")
                                        
                                        Spacer()
                                            .frame(height: 5)
                                        
                                        Text(book.getAuthor)
                                            .lineLimit(1)
                                            .font(.system(size: 13))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 5)
                                }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .searchable(text: $fetchBookInfoViewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter Book Title")
            .accessibilityAddTraits(.isSearchField)
            .onChange(of: fetchBookInfoViewModel.searchText) {
                if fetchBookInfoViewModel.searchText.isEmpty {
                    fetchBookInfoViewModel.books.removeAll()
                }
            }
            .onSubmit(of: .search) {
                fetchBookInfoViewModel.fetchBookInfo()
            }
            .overlay {
                if fetchBookInfoViewModel.searchText.isEmpty {
                    ContentUnavailableView {
                        Label("No Result Found", systemImage: "magnifyingglass")
                    } description: {
                        Text("Enter a book title to begin searching!")
                            .accessibilityLabel("Enter a book title to begin searching!")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Find Book")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: {
                        isShowingSheet.toggle()
                    })
                }
            }
        }
    }
}

#Preview {
    SearchView(isShowingSheet: .constant(false), collectionBooks: [Book]())
}
