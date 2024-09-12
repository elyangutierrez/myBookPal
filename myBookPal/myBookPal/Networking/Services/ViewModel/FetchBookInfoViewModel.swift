//
//  FetchBookInfo.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/12/24.
//

import Foundation

@Observable
class FetchBookInfoViewModel {
    var books: [VolumeInfo] = []
    var searchText = ""
    
    func fetchBookInfo() {
        let lowercasedText = searchText.lowercased()
        guard let encodedQuery = lowercasedText.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)") else {
            return
        } // the encodedQuery is what the user has searched for in which is then plugged into the url
        print("---------------------------------")
        print("The url has been recieved!")
        
        URLSession.shared.dataTask(with: url) { data, response, error in // fetchs the data within the url and uses a closure to store the data, response, and error parameters
            print("---------------------------------")
            if let data = data {
                print("Recieved the data..")
                let someData = String(data: data, encoding: .utf8)
                print(someData ?? "None")
                do {
                    let response = try JSONDecoder().decode(BookResponse.self, from: data) // decodes the response into the BookAPIType structs from the data
                    print("The response was recieved.")
                    
                    DispatchQueue.main.async { // allows this process to be done in the background without causing lag
                        self.books = response.items.compactMap { $0.volumeInfo } // sets book to the infomation inside of the current volumeInfo object
                    }
                } catch {
                    print("The do block failed: \(error.localizedDescription)")
                }
            } else {
                print("The data couldn't be recieved")
            }
        }.resume() // is what runs the URLSession
    }
}
