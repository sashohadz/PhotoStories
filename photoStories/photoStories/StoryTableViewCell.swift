//
//  StoryTableViewCell.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

protocol StoryTableViewCellDelegate{
    func didPressBookmarkButton(inCell:StoryTableViewCell)
}

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var bookmarkStory: UIButton!
    @IBOutlet weak var storyDetailLabel: UILabel!
    
    var delegate: StoryTableViewCellDelegate?
    
    var isBookmarked:Bool! = false {
        didSet{
            switch isBookmarked {
            case true:
                self.storyImageView.layer.borderWidth = 4.0
                let bookMarkdColor = UIColor(colorLiteralRed: 0.51, green: 0.87, blue: 0.78, alpha: 0.4)
                self.storyImageView.layer.borderColor = bookMarkdColor.cgColor
            case false:
                self.storyImageView.layer.borderWidth = 0.0
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bookmarkStory.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func bookmarkSelected(_ sender: UIButton) {
        self.buttonWasPressed()
        if (!isBookmarked) {
            isBookmarked = true
            self.bookmarkStory.isSelected = true
        } else {
            isBookmarked = false
            self.bookmarkStory.isSelected = false
        }
    }
    
    func buttonWasPressed() {
        self.delegate?.didPressBookmarkButton(inCell: self)
    }
}
