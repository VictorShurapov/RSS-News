//
//  RSSFeedUIViewController.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/6/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
