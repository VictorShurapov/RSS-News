    //
    //  NewsFeedViewController.swift
    //  RSSNewsfeed
    //
    //  Created by Viktor S on 5/2/19.
    //  Copyright © 2019 Viktor S. All rights reserved.
    //
    
    import UIKit
    import SWRevealViewController
    import Kingfisher
    import RealmSwift
    
    class NewsFeedViewController: UIViewController {
        
        // MARK: - IBOutlets & IBActions
        @IBOutlet weak var menuButton: UIBarButtonItem!
        @IBOutlet weak var tableView: UITableView!
        
        // MARK: - Properties
        let viewModel = NewsFeedViewModel()
        let networkReachability = NetworkReachability()
        
        // MARK: - LoadView
        override func viewDidLoad() {
            super.viewDidLoad()
            
            viewModel.xmlParser.delegate = self
            
            viewModel.populateDefaultSources()
            
            // Navigation
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            self.navigationItem.title = viewModel.currentChannelName
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Hide the navigation bar on the this view controller
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            
            networkCheck()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Show the navigation bar on the next view controllers
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        // MARK: - Methods
        fileprivate func networkCheck() {
            // populate tableView with news- new ones or fetched from Realm
            if networkReachability.isNetworkAvailable() {
                viewModel.clearPreviousNews()
                viewModel.xmlParse()
                
            } else {
                self.showAlert(errorTitle: "Network is unavailable", errorMessage: "Please check you connection and select newssource once again.")
                viewModel.populateNewsArray()
                tableView.reloadData()
            }
        }
        
        fileprivate func open(url: String, currentRow: Int) {
            
            if let checkedURL = URL(string: url) {
                
                UIApplication.shared.open(checkedURL, options: [:]) { _ in
                    
                    // get current item and deselect it
                    let index = IndexPath(row: currentRow, section: 0)
                    self.tableView.deselectRow(at: index, animated: true)
                }
            }
        }
        
        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showWebView" {
                
                if let webViewController = segue.destination as? WebViewController {
                    
                    guard let selectedChannelIndex = tableView.indexPathForSelectedRow else { return }
                    
                    let currentNews = viewModel.xmlParser.newsArray[selectedChannelIndex.row]
                    
                    let link = currentNews.link
                    webViewController.url = URL(string: link)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    extension NewsFeedViewController: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.xmlParser.newsArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let newsFeedCell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell") as? NewsFeedTableViewCell else { return UITableViewCell() }
            
            let url = viewModel.xmlParser.newsArray[indexPath.row].imageURL
            
            if !url.isEmpty {
                newsFeedCell.newsImage.kf.setImage(with: URL(string: url))
            } else {
                newsFeedCell.newsSourcePlaceholder.isHidden = false
                newsFeedCell.newsSourcePlaceholder.text = viewModel.currentChannelName
                newsFeedCell.newsImage.image = UIImage(named: "rss")
                newsFeedCell.newsImage.alpha = 0.1
            }
            
            newsFeedCell.newsTitle.text = viewModel.xmlParser.newsArray[indexPath.row].title
            
            return newsFeedCell
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    extension NewsFeedViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 201
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showWebView", sender: nil)
        }
    }
    
    extension NewsFeedViewController: NewsFeedXMLParserDelegate {
        func parsingWasFinished() {
            self.tableView.reloadData()
        }
    }
