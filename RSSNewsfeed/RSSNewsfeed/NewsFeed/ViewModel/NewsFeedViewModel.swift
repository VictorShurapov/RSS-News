//
//  NewsFeedViewModel.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit
import RealmSwift

class NewsFeedViewModel {
    
    // MARK: - Properties
    var currentNewsChannelSource = "https://www.wired.com/feed/rss"
    var currentChannelName = "Wired"
    var currentNewsSourceModel: NewsSource!

    let realm = RealmService.service.realm
    lazy var channelList: Results<NewsSource>? = RealmService.service.getChannelList()

    
    // MARK: - Methods
    func populateDefaultSources() {

        if channelList?.count == 0 {
            
            try! realm?.write() {
                
                let defaultNewsSources: [(String, String)] = [("Wired", "https://www.wired.com/feed/rss"), ("New Yorker.Daily Cartoon", "https://www.newyorker.com/feed/cartoons/daily-cartoon"), ("Buzzfeed", "https://www.buzzfeed.com/world.xml"), ("Time", "http://feeds.feedburner.com/time/world"), ("NYTimes", "http://rss.nytimes.com/services/xml/rss/nyt/US.xml"), ("Meduza", "https://meduza.io/rss/all"),("SF Gate", "https://www.sfgate.com/bayarea/feed/Bay-Area-News-429.php")]
                
                for newsSource in defaultNewsSources {
                    let newSource = NewsSource()
                    newSource.sourceName = newsSource.0
                    newSource.sourceLink = newsSource.1
                    newSource.id = UUID().uuidString
                    
                    realm?.add(newSource)
                }
            }
            channelList = RealmService.service.getChannelList()
        }
    }
}
