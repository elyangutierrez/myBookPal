//
//  NetworkMonitor.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 7/10/24.
//

import Foundation
import Network

@Observable
final class NetworkMonitor {
    private let networkMonitor = NWPathMonitor() // tracks network path changes
    private let workerQueue = DispatchQueue(label: "Monitor") // handles network monitoring ops
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in // is called whenever there is a change in path
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue) // monitors the network path
    }
}

