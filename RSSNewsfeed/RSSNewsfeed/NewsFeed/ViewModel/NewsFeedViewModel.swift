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
    var currentNewsSourceModel: NewsSource! {
        didSet {
            xmlParser.newsModel = currentNewsSourceModel
        }
    }
    
    let realm = RealmService.service
    var xmlParser = NewsFeedXMLParser()
    lazy var channelList: Results<NewsSource>? = realm.getChannelList()
    
    // MARK: - Methods
    func populateDefaultSources() {
        
        if channelList?.count == 0 {
            
                let defaultNewsSources: [(String, String)] = [("Wired", "https://www.wired.com/feed/rss"), ("New Yorker.Daily Cartoon", "https://www.newyorker.com/feed/cartoons/daily-cartoon"), ("Buzzfeed", "https://www.buzzfeed.com/world.xml"), ("Time", "http://feeds.feedburner.com/time/world"), ("NYTimes", "http://rss.nytimes.com/services/xml/rss/nyt/US.xml"), ("Meduza", "https://meduza.io/rss/all"),("SF Gate", "https://www.sfgate.com/bayarea/feed/Bay-Area-News-429.php")]
                
                for newsSource in defaultNewsSources {
                    realm.writeNewsSourceFrom(tuple: newsSource)
                }
            
            channelList = realm.getChannelList()
        }
        
        // get default first newsModel if it's nil
        if xmlParser.newsModel == nil {
            if let defaultNewsModel = realm.getChannelSourceModelFor(selectedChannelName: currentChannelName) {
                currentNewsSourceModel = defaultNewsModel
            }
        }
    }
    
    func xmlParse() {
        guard let url = URL(string: currentNewsChannelSource) else { return }
        xmlParser.startParsingWithContentsOfURL(rssURL: url)
    }
    
    func clearPreviousNews() {
        let news = getNewsFromRealm()
        
            for article in news {
                realm.remove(object: article)
            }
        }
    
    func getNewsFromRealm() -> [NewsPost] {
        guard let news = realm.getNews() else { return [NewsPost]() }
        let sourceName = currentChannelName
        let newsForCurrentChannel = news.filter { $0.newsSource.sourceName == sourceName }
        return newsForCurrentChannel
    }
    
    func populateNewsArray() {
        xmlParser.newsArray = getNewsFromRealm()
    }
}
