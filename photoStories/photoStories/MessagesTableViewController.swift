//
//  MessagesTableViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 3/17/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

class MessagesTableViewController: UITableViewController {
    // TO UPLDATE - OUTDATED CODE
    var inboxMessages = [LPInboxMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Leanplum.inbox().onChanged {
            self.inboxMessages = Leanplum.inbox().allMessages() as! [LPInboxMessage]
            self.inboxMessages.reverse()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inboxMessages.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let message: LPInboxMessage = self.inboxMessages[row]
//        if (!message.isRead) {
//            cell.setHighlighted(true, animated: true)
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let unreadColor = UIColor(colorLiteralRed: 0.51, green: 0.87, blue: 0.78, alpha: 0.4)
        let selectedView = UIView()
        selectedView.backgroundColor = unreadColor
        cell.selectedBackgroundView = selectedView
        
        let row = indexPath.row
        let message: LPInboxMessage = self.inboxMessages[row]
        
        let title = message.title()
        cell.textLabel?.text = title
        
        let subtitle = message.subtitle()
        cell.detailTextLabel?.text = subtitle
        
        if let imageFilePath = message.imageFilePath() {
             cell.imageView?.image = UIImage(contentsOfFile: imageFilePath)
        }
        
//        print("Showing Inbox message with: id##instanceId \(message.messageId())")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageAtRow = self.inboxMessages[indexPath.row]
        let title = messageAtRow.title()
        let text = messageAtRow.subtitle()
        presentMessage(title: title!, text: text!, inboxMessageId: messageAtRow)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            self.inboxMessages[indexPath.row].remove()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func presentMessage(title: String, text: String, inboxMessageId: LPInboxMessage) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            inboxMessageId.read()
//            print("OK, message with id \(inboxMessageId.minboxessageId()) is now marked as read")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
