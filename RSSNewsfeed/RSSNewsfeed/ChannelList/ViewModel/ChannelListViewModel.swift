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
    let realm = RealmService.service
    lazy var channelList: Results<NewsSource>? = RealmService.service.getChannelList()
    
    func writeNewsSourcetoRealmFrom(tuple: (String, String)) {
        realm.writeNewsSourceFrom(tuple: tuple)
    }
    
    func removeObjectFromRealm(_ object: NewsSource) {
        realm.remove(object: object)
    }
    
    
}
