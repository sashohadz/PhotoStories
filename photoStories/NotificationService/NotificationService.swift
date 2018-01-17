//
//  NotificationService.swift
//  NotificationService
//
//  Created by Sasho Hadzhiev on 6/22/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var downloadTask: URLSessionDownloadTask?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        self.bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        let userInfo = request.content.userInfo;
        
        // LP_URL is the key that is used from Leanplum to
        // send the image URL in the payload.
        //
        // If there is no LP_URL in the payload than
        // the code will still show the push notification.
        if userInfo["LP_URL"] == nil {
            self.contentHandler!(self.bestAttemptContent!);
            return;
        }
        
        // If there is an image in the payload, this part
        // will handle the downloading and displaying of the image.
        if let attachmentMedia = userInfo["LP_URL"] as? String {
            let mediaUrl = URL(string: attachmentMedia)
            let LPSession = URLSession(configuration: .default)
            LPSession.downloadTask(with: mediaUrl!, completionHandler: { temporaryLocation, response, error in
                if error != nil {
                    print("Leanplum: Error with downloading rich push: \(String(describing: error?.localizedDescription))")
                    contentHandler(self.bestAttemptContent!)
                    return;
                }
                
                let fileType = self.determineType(fileType: (response?.mimeType)!)
                let fileName = temporaryLocation?.lastPathComponent.appending(fileType)
                let temporaryDirectory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName!)
                
                do {
                    try FileManager.default.moveItem(at: temporaryLocation!, to: temporaryDirectory)
                    print(FileManager.default.fileExists(atPath: temporaryDirectory.path))
                    let attachment = try UNNotificationAttachment(identifier: "", url: temporaryDirectory, options: nil)
                    self.bestAttemptContent?.attachments = [attachment]
                    contentHandler(self.bestAttemptContent!)
                } catch {
                    print("Leanplum: Error with the rich push attachment: \(error)")
                    contentHandler(self.bestAttemptContent!)
                    return;
                }
            }).resume()
            
        }
    }
    
    // MARK: - Leanplum Rich Push
    func determineType(fileType: String) -> String {
        // Determines the file type of the attachment to append to URL.
        if fileType == "image/jpeg" {
            return ".jpg";
        }
        if fileType == "image/gif" {
            return ".gif";
        }
        if fileType == "image/png" {
            return ".png";
        } else {
            return ".tmp";
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        //        self.downloadTask?.cancel()
        
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}



