//
//  NewsFeedXMLParser.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit

protocol NewsFeedXMLParserDelegate {
    func parsingWasFinished()
}


class NewsFeedXMLParser: NSObject, XMLParserDelegate {
    
    var arrParsedData = [[String: String]]()
    
    var currentDataDictionary = [String: String]()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate: NewsFeedXMLParserDelegate?
    
    var mediaUrl = ""
    
    
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
}
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            
            if elementName == "link" {
                foundCharacters = (foundCharacters as NSString).substring(to: 3)
            }
            
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            // last element close currentDataDictionary
            if currentElement == "media:thumbnail"/*"pubDate"*/ {
                arrParsedData.append(currentDataDictionary)
            }
        }
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
}
