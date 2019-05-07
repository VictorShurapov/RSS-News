//
//  NetworkReachability.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/6/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import Foundation
import Network

class NetworkReachability {
    
    var pathMonitor: NWPathMonitor!
    var path1: NWPath?
    var pathUpdateHandler: ((NWPath) -> Void) = { path in
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }
    
    let backgroundQueue = DispatchQueue.global(qos: .background)
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroundQueue)
    }
    
    func isNetworkAvailable() -> Bool {
            if pathMonitor.currentPath.status == NWPath.Status.satisfied {
                return true
            } else {
                return false
        }
    }
}
