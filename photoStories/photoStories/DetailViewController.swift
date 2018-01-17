//
//  DetailViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

class DetailViewController: UIViewController {

    @IBOutlet weak var largerImageView: UIImageView!    
    @IBOutlet weak var whatsNewButton: UIButton!
    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let unreadCount = Leanplum.inbox().unreadCount()
        let allMessagesCount = Leanplum.inbox().count()
        self.unreadLabel.text = String(unreadCount)
        self.readLabel.text = String(allMessagesCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Leanplum.forceContentUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func whatsNewButtonPressed(_ sender: UIButton) {
        Leanplum.track("News")
        Leanplum.setUserAttributes(["Subscribed for News":"Yes"])
        print(["Subscribed for News":"Yes"])
    }
}
