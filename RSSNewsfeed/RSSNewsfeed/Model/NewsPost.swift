//
//  NewsPost.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/7/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import Foundation
import RealmSwift

class NewsPost: Object {
    @objc dynamic var title = ""
    @objc dynamic var link = ""
    @objc dynamic var pubDate = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var newsSource: NewsSource!

   // @objc dynamic var created = Date()
}

/*
 Id (UUID)
 Source name
 Source link
 -    News list
 */
