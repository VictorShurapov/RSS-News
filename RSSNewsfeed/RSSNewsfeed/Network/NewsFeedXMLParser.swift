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
        
        foundCharacters = ""
        
        currentElement = elementName
        
        if elementName == "media:thumbnail" || elementName == "media:content" || elementName == "enclosure" {
            guard let url = attributeDict["url"] else { return }
            foundCharacters += url
           // currentDataDictionary[currentElement] = foundCharacters
        }
        
}
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            print("Element: \(elementName), \(foundCharacters)")
            if elementName == "media:thumbnail" || elementName == "media:content" || elementName == "enclosure" {
                currentDataDictionary["media:thumbnail"] = foundCharacters
            } else {
                currentDataDictionary[currentElement] = foundCharacters
            }
            foundCharacters = ""
        }
            // last element close currentDataDictionary
            if elementName == "item" { //"media:thumbnail" || currentElement == "media:content" {
                
            arrParsedData.append(currentDataDictionary)
            newsArray = populateNews()
                
                RealmService.service.addNewsFrom(dataDictionary: currentDataDictionary, newsSourceModel: newsModel)
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" || currentElement == "pubDate" || currentElement == "link" {
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
    func populateNews() -> [NewsPost] {
        
        let newsArray = arrParsedData.map { parsedData -> NewsPost  in
            let news = NewsPost()
            
            guard let title = parsedData["title"] else { return news }
            news.title = title
            
            guard let link = parsedData["link"] else { return news }
            news.link = link
            
            guard let imageURL = parsedData["media:thumbnail"] else { return news }
            news.imageURL = imageURL
            
            guard let pubDate = parsedData["pubDate"] else { return news }
            news.pubDate = pubDate
            
            news.newsSource = newsModel
            
            return news
        }
        return newsArray
    }
}
