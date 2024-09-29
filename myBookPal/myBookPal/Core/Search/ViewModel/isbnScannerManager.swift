//
//  ISBNScannerManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/28/24.
//

import Foundation
import VisionKit

@Observable
class isbnScannerManager: DataScannerViewControllerDelegate {
    var scannerAvaliable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    func startScanning() {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.ean13])],
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        viewController.delegate = self
        try? viewController.startScanning()
        
        print("Running scanner.")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        //
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        //
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        //
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            print(text)
        case .barcode(let barcode):
            print(barcode)
            
            // TODO: store the barcode and fetch data
            dataScanner.stopScanning()
            dataScanner.dismiss(animated: true)
        default:
            print("Unknown item.")
        }
    }
}
