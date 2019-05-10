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
    lazy var channelList: Results<NewsSource> = { self.realm.objects(NewsSource.self) }()
    
}
