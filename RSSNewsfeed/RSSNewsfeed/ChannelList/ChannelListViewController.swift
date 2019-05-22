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
    @IBAction func addNewsSource(_ sender: Any) {
        showAlertToAddNewsSourceWith()
    }
    
    // MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = 300
    }
    
    // MARK: - Properties
    let viewModel = ChannelListViewModel()
    
    var addNewsTuple = ("", "") {
        didSet {
            
            if !addNewsTuple.0.isEmpty || (addNewsTuple.1 != "https://") {
                viewModel.writeNewsSourcetoRealmFrom(tuple: addNewsTuple)
                tableView.reloadData()
            } else {
                self.showAlert(errorTitle: "Add NewsChannel. Please try again.", errorMessage: "All fields are required.")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsFeed" {
            if let navigationController = segue.destination as? UINavigationController {
                if let newsFeedViewController = navigationController.viewControllers.last as? NewsFeedViewController {
                    guard let selectedChannelIndex = tableView.indexPathForSelectedRow else { return }
                    
                    guard let channelListChecked = viewModel.channelList else { return }
                    
                    let selectedChannelName = channelListChecked[selectedChannelIndex.row].sourceName
                    let selectedChannelSource = channelListChecked[selectedChannelIndex.row].sourceLink
                    
                    newsFeedViewController.viewModel.currentChannelName = selectedChannelName
                    newsFeedViewController.viewModel.currentNewsChannelSource = selectedChannelSource
                    
                    guard let selectedNewsSourceModel = RealmService.service.getChannelSourceModelFor(selectedChannelName: selectedChannelName) else { return }
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
        
        guard let channelListChecked = viewModel.channelList else { return 0 }
        
        return channelListChecked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let channelListCell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell") else { return UITableViewCell() }
        
        guard let channelListChecked = viewModel.channelList else { return UITableViewCell() }
        
        channelListCell.textLabel?.text = channelListChecked[indexPath.row].sourceName
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            guard let channelListChecked = viewModel.channelList else { return }
            
            let objectToRemove = channelListChecked[indexPath.row]
            
            viewModel.removeObjectFromRealm(objectToRemove)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension ChannelListViewController {
    func showAlertToAddNewsSourceWith() {
        
        let alert = UIAlertController(title: "Add News Source", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (userField) in
            userField.placeholder = "News Source Name"
        }
        
        alert.addTextField { (passWordField) in
            passWordField.placeholder = "RSS link"
            passWordField.text = "https://"
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        //the confirm action taking the inputs
        let acceptAction = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            
            guard let newsSourceTextField = alert?.textFields?[0], let rssLinkTextField = alert?.textFields?[1] else {
                print("Alert textField is nil")
                return
            }
            guard let newsSourceName = newsSourceTextField.text, let rssLink = rssLinkTextField.text else {
                print("Issue with text in Alert textField")
                return
            }
            self.addNewsTuple = (newsSourceName, rssLink)
        })
        
        //adding the actions to alertController
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }
}
