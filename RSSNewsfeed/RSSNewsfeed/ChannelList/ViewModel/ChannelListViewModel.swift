//
//  ChannelListViewModel.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit
import RealmSwift

class ChannelListViewModel {

    // MARK: - Properties
    let realm = RealmService.service.realm
    lazy var channelList: Results<NewsSource>? = RealmService.service.getChannelList()

    // MARK: - Methods
    func writeNewsSourcetoRealm(tuple: (String, String)) {
        let newSource = NewsSource()
        newSource.sourceName = tuple.0
        newSource.sourceLink = tuple.1
        newSource.id = UUID().uuidString
        
        try! realm?.write() {
            realm?.add(newSource)
        }
    }
    
    func removeObjectFromRealm(_ object: NewsSource) {
        try! realm?.write {
            realm?.delete(object)
        }
    }
}
