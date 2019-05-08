//
//  NewsFeedXMLParser.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit
import RealmSwift

protocol NewsFeedXMLParserDelegate {
    func parsingWasFinished()
}


class NewsFeedXMLParser: NSObject, XMLParserDelegate {
    
    var arrParsedData = [[String: String]]()
    
    var newsArray = [NewsPost]()
    
    var currentDataDictionary = [String: String]()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate: NewsFeedXMLParserDelegate?
    
    var mediaUrl = ""
    
    var newsModel: NewsSource!
    
    func startParsingWithContentsOfURL(rssURL: URL) {
        guard let parser = XMLParser(contentsOf: rssURL) else { return }
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: XMLParserDelegate Methods
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parsingWasFinished()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "media:thumbnail" {
            guard let url = attributeDict["url"] else { return }
            foundCharacters += url
            currentDataDictionary[currentElement] = foundCharacters
        }
        
        if elementName == "media:content" {
            guard let url = attributeDict["url"] else { return }
            foundCharacters += url
            currentDataDictionary["media:thumbnail"] = foundCharacters
        }
}
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
                        
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            // last element close currentDataDictionary
            if currentElement == "media:thumbnail" || currentElement == "media:content" {
                
                arrParsedData.append(currentDataDictionary)
               newsArray = populateNews()
                
                addNewsFrom(dataDictionary: currentDataDictionary)
            }
        }
    }
    
    func populateNews() -> [NewsPost] {
        
        let newsArray = arrParsedData.map { parsedData -> NewsPost  in
            let news = NewsPost()
            
            guard let title = parsedData["title"] else { return NewsPost() }
            news.title = title
            
            guard let link = parsedData["link"] else { return NewsPost() }
            news.link = link
            
            guard let pubDate = parsedData["pubDate"] else { return NewsPost() }
            news.pubDate = pubDate
            
            guard let imageURL = parsedData["media:thumbnail"] else { return NewsPost() }
            news.imageURL = imageURL
            
            news.newsSource = newsModel
            
            return news
        }
        return newsArray
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" || currentElement == "link" || currentElement == "pubDate" {
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
    func addNewsFrom(dataDictionary: [String: String]) {
        let realm = try! Realm()
        
        try! realm.write {
            let newArticle = NewsPost()
            
            guard let title = dataDictionary["title"] else { return }
            newArticle.title = title
            
            guard let link = dataDictionary["link"] else { return }
            newArticle.link = link
            
            guard let pubDate = dataDictionary["pubDate"] else { return }
            newArticle.pubDate = pubDate
            
            guard let imageURL = dataDictionary["media:thumbnail"] else { return }
            newArticle.imageURL = imageURL
            
            newArticle.newsSource = newsModel
            
            realm.add(newArticle)
        }
    }
}
