//
//  StoreKitManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/11/24.
//

import Foundation
import StoreKit

enum StoreError: LocalizedError {
    case failedVerification
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Failed to verify verification"
        case .system(let error):
            return error.localizedDescription
        }
    }
}

enum StoreAction: Equatable {
    case successful
    case failed(StoreError)
    
    static func == (lhs: StoreAction, rhs: StoreAction) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

typealias PurchaseResult = Product.PurchaseResult
typealias TransactionListener = Task<Void, Error>

@Observable
class StoreKitManager: @unchecked Sendable {
    //
    
    private(set) var items = [Product]()
    private(set) var action: StoreAction?
    
    var hasError = false
    
    private var transactionListener: TransactionListener?
    
    init() {
        transactionListener = configureTransactionListener()
        Task {
            await retrieveProducts()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    func purchase(_ item: Product) async {
        do {
            let result = try await item.purchase()
            
            try await handlePurchase(from: result)
        } catch {
            print(error)
        }
    }
    
    func reset() {
        action = nil
    }
}

private extension StoreKitManager {
    
    func configureTransactionListener() -> TransactionListener {
        Task.detached(priority: .background) {
            do {
                for await result in Transaction.updates {
                    let transaction = try self.checkVerified(result)
                    
                    self.action = .successful
                    
                    await transaction.finish()
                }
            } catch {
                self.action = .failed(.system(error))
                print(error)
            }
        }
    }
    
    @MainActor
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: storeConstants).sorted(by: { $0.price < $1.price })
            items = products
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {
        case .success(let verification):
            print("The purchase was a success!")
            
            let transaction = try checkVerified(verification)
            
            action = .successful
            
            await transaction.finish()
            
        case .pending:
            print("The purchase is pending.")
            break
        case .userCancelled:
            print("The user canceled the purchase.")
            throw StoreKitError.userCancelled
        default:
            break
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
