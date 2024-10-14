//
//  MailComposer.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/21/24.
//

import Foundation
import SwiftUI
import MessageUI

struct MailComposer: UIViewControllerRepresentable {
    var category: String
    var description: String
    var dateCreated: String
    var timeCreated: String
    
    class Coordinator: NSObject, @preconcurrency MFMailComposeViewControllerDelegate {
        
        /* This class handles with the dismissal of email composer */
        
        var parent: MailComposer
        
        init(_ parent: MailComposer) {
            self.parent = parent
        }
        
        @MainActor func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        
        // uses the coordinator to handle handle email events
        // then sets the subject and message with the users ticket.
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["mybookpalhelp@gmail.com"])
        vc.setSubject("Support Request: \(category)")
        vc.setMessageBody("Ticket created at: \(dateCreated) \(timeCreated)\n\nCategory: \(category)\n\nDescription:\n\(description)", isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    static func isAvaliable() -> Bool {
        
        // checks if the users phone is capable of sending emails
        
        return MFMailComposeViewController.canSendMail()
    }
}
