//
//  ChannelListViewController.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit
import SWRevealViewController
import RealmSwift

class ChannelListViewController: UIViewController {
    
    // MARK: - IBOutlets & IBActions
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = 300
    }
    
    // MARK: - Properties
    let viewModel = ChannelListViewModel()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsFeed" {
            if let navigationController = segue.destination as? UINavigationController {
                if let newsFeedViewController = navigationController.viewControllers.last as? NewsFeedViewController {
                    guard let selectedChannelIndex = tableView.indexPathForSelectedRow else { return }
                    
                    let selectedChannelName = viewModel.channelList[selectedChannelIndex.row].sourceName
                    let selectedChannelSource = viewModel.channelList[selectedChannelIndex.row].sourceLink
                    
                    newsFeedViewController.viewModel.currentChannelName = selectedChannelName
                    newsFeedViewController.viewModel.currentNewsChannelSource = selectedChannelSource
                    
                    guard let selectedNewsSourceModel = RealmService.service.realm.object(ofType: NewsSource.self, forPrimaryKey: selectedChannelName) else { return }
                
                    newsFeedViewController.viewModel.currentNewsSourceModel = selectedNewsSourceModel
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource Methods
extension ChannelListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let channelListCell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell") else { return UITableViewCell() }
        channelListCell.textLabel?.text = viewModel.channelList[indexPath.row].sourceName
        
        
        return channelListCell
    }
}

// MARK: - UITableViewDelegate Methods
extension ChannelListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showNewsFeed", sender: self)
    }
}
