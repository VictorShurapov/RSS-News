//
//  NewsFeedViewController.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit
import SWRevealViewController

class NewsFeedViewController: UIViewController {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = NewsFeedViewModel()
    
    // MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.navigationItem.title = viewModel.currentNewsChannelSource
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on the next view controllers
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}

// MARK: - UITableViewDataSource Methods
extension NewsFeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let newsFeedCell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell") as? NewsFeedTableViewCell else { return UITableViewCell() }
        newsFeedCell.newsImage.image = viewModel.newsDataSource[indexPath.row].0
        newsFeedCell.newsTitle.text = viewModel.newsDataSource[indexPath.row].1
        return newsFeedCell
    }
}

// MARK: - UITableViewDelegate Methods
extension NewsFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 201
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // self.performSegue(withIdentifier: "showNewsFeed", sender: self)
    }
}
