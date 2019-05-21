//
//  NewsSource.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/7/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import Foundation
import RealmSwift

class NewsSource: Object {
    @objc dynamic var id = ""
    @objc dynamic var sourceName = ""
    @objc dynamic var sourceLink = ""
    
    let news = LinkingObjects(fromType: NewsPost.self, property: "newsSource")
    
    override static func primaryKey() -> String? {
        return "sourceName"
    }
}
