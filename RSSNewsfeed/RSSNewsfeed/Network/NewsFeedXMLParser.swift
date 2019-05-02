//
//  NewsFeedXMLParser.swift
//  RSSNewsfeed
//
//  Created by Viktor S on 5/2/19.
//  Copyright © 2019 Viktor S. All rights reserved.
//

import UIKit

protocol XMLParserDelegate {
    func parsingWasFinished()
}


class NewsFeedXMLParser: NSObject, XMLParserDelegate {
    
    var arrParsedData = [[String: String]]()
    
    var currentDataDictionary = [String: String]()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate: XMLParserDelegate?
    
    
    func startParsingWithContentsOfURL(rssURL: URL) {
        guard let parser = XMLParser(contentsOf: rssURL) else { return }
        parser.delegate = self
        parser.parse()
        
    }
}
