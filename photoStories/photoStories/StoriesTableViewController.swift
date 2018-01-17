//
//  StoriesTableViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let storiesData:[[StoryDataType:String]] = [
        [.storyImage:"moon",
         .storyName:"stays",
         .storyShortDetail:"stays"],
        [.storyImage:"places",
         .storyName:"places",
         .storyShortDetail:"places"],
        [.storyImage:"rewards",
         .storyName:"rewards",
         .storyShortDetail:"rewards"],
        [.storyImage:"card",
         .storyName:"Payment",
         .storyShortDetail:"Payment"],
        [.storyImage:"star",
         .storyName:"Favourites",
         .storyShortDetail:"Favourites"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        var userLoggedIn:Bool!
        
        if let autoUserLoginEnabled = UserDefaults.standard.object(forKey: UserDefaultKeys.autoLoginEnabled.rawValue) {
            userLoggedIn = autoUserLoginEnabled as? Bool
        }
        else {
            userLoggedIn = false
        }
        
        if (!userLoggedIn) {
            self.logoutButton.title = "Login"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storiesData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCellIdentifier", for: indexPath) as! StoryTableViewCell
        let data = self.storiesData[indexPath.row]
        cell.storyImageView.image = UIImage(named: data[.storyImage]!)
        cell.storyDetailLabel.text = data[.storyName]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! StoryTableViewCell
        let storyShortText = selectedCell.storyDetailLabel.text
        print("Track Selected item with item: \(storyShortText ?? "")")
        Leanplum.track("Selected item", withValue: Double(selectedCell.isBookmarked.hashValue), andParameters: ["item":storyShortText!])
        self.performSegue(withIdentifier: "ToStoryDetailsSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.autoLoginEnabled.rawValue)
        self.modalTransitionStyle = .crossDissolve
        self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
    }
    
    func didPressBookmarkButton(inCell:StoryTableViewCell) {
        inCell.isBookmarked = !inCell.isBookmarked
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let destination = segue.destination as! DetailViewController
            let imageName = self.storiesData[self.tableView.indexPathForSelectedRow!.row][.storyImage]
            destination.loadViewIfNeeded()
            destination.largerImageView.image = UIImage(named: imageName!)
        }
    }
}
