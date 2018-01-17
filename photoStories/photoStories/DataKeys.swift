//
//  DataKeys.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    case username = "username"
    case password = "password"
    case autoLoginEnabled = "autoLoginEnabled"
}

enum StoryDataType {
    case storyImage, storyName, storyShortDetail, isBookmarked
}
