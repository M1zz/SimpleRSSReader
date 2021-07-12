//
//  NewsTableViewController.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/03.
//

import UIKit

class NewsTableViewController: UITableViewController {

    private let feedParser = FeedParser()
    private var rssItems:[RSSItem]?
    private var cellStates:[CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFeedData()
    }
    
    private func setFeedData() {
        feedParser.parseFeed(feedURL: "http://www.apple.com/main/rss/hotnews/hotnews.rss") { result in
            switch result {
            case .success(let feeds):
                self.rssItems = feeds
                self.cellStates = Array(repeating: .collapsed, count: self.rssItems?.count ?? 0)
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rssItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableViewCell
        
        if let item = rssItems?[indexPath.row] {
            (cell.titleLabel.text, cell.descriptionLabel.text, cell.dateLabel.text) = (item.title, item.description, item.pubDate)
            
            if let cellState = cellStates?[indexPath.row] {
                cell.descriptionLabel.numberOfLines = cellState == .expanded ? 0: 4
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        
        tableView.beginUpdates()
        cell.descriptionLabel.numberOfLines = cell.descriptionLabel.numberOfLines == 4 ? 0 : 4
        cellStates?[indexPath.row] = cell.descriptionLabel.numberOfLines == 4 ? .collapsed : .expanded
        tableView.endUpdates()
    }
}
