//
//  RealmService.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/10/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let service = RealmService()
    
    let realm = try! Realm()

    func addNewsFrom(dataDictionary: [String: String], newsSourceModel:  NewsSource) {
        
        try! realm.write {
            let newArticle = NewsPost()
            
            guard let title = dataDictionary["title"] else { return }
            newArticle.title = title
            
            guard let link = dataDictionary["link"] else { return }
            newArticle.link = link
            
            guard let pubDate = dataDictionary["pubDate"] else { return }
            newArticle.pubDate = pubDate
            
            guard let imageURL = dataDictionary["media:thumbnail"] else { return }
            newArticle.imageURL = imageURL
            
            newArticle.newsSource = newsSourceModel
            
            realm.add(newArticle)
        }
    }

    
}
