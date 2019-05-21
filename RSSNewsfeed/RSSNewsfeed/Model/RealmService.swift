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
    
    //let realm = try! Realm()
    
     var realm: Realm? {
        do {
            return try Realm()
        } catch let error {
            print("Could not write to database: " + error.localizedDescription)
            return nil
        }
    }
    
    func getChannelList() -> Results <NewsSource>? {
        if let realmChecked = realm {
            return realmChecked.objects(NewsSource.self)
        } else {
            return nil
        }
    }
    
    func getNews() -> [NewsPost]? {
        if let realmChecked = realm {
            return Array(realmChecked.objects(NewsPost.self))
        } else {
            return nil
        }
    }
    
    
    func getChannelSourceModelFor(selectedChannelName: String) -> NewsSource? {
        if let realmChecked = realm {
            return realmChecked.object(ofType: NewsSource.self, forPrimaryKey: selectedChannelName)
        } else {
            return nil
        }
    }

     func addNewsFrom(dataDictionary: [String: String], newsSourceModel:  NewsSource) {
        
        try! realm?.write {
            let newArticle = NewsPost()
            
            if let title = dataDictionary["title"] {
            newArticle.title = title
            }
            
            if let link = dataDictionary["link"] {
            newArticle.link = link
            }
            
            if let pubDate = dataDictionary["pubDate"] {
            newArticle.pubDate = pubDate
            }
            
            if let imageURL = dataDictionary["media:thumbnail"] {
            newArticle.imageURL = imageURL
            }
            
            newArticle.newsSource = newsSourceModel
            
            realm?.add(newArticle)
        }
    }

    
}
