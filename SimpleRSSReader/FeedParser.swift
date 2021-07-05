//
//  FeedParser.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/04.
//

import Foundation

enum RSSError: String, Error {
    case invalidURL = "feed URL is invalid"
    case unableToComplete = "요청을 완료할 수 없습니다. 네트워크 연결을 확인해주세요."
    case invalidResponse = "유효하지 않은 서버로 부터의 응답입니다. 다시 요청해주세요."
    case invalidData = "서버로 받은 데이터가 유효하지 않습니다. 다시 요청해주세요."
}

final class FeedParser: NSObject {
    
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
            
            guard let response = response else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
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
}
