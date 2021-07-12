//
//  FeedParser.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/04.
//

import Foundation



final class FeedParser: NSObject {
    
    private var rssItems:[RSSItem] = []
    private var currentElement = ""
    
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    func parseFeed(feedURL: String,
                   completed: @escaping (Result<[RSSItem], RSSError>) -> Void) -> Void {
        
        guard let feedURL = URL(string: feedURL) else {
            return completed(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: feedURL, completionHandler: { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
//            
//            guard let response = response else {
//                completed(.failure(.invalidResponse))
//                return
//            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completed(.success(self.rssItems))
        }).resume()
    }
}

extension FeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        /// Note: current string may only contain part of info.
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems.append(rssItem)
        }
    }
    
}
