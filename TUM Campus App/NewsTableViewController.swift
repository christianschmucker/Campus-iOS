//
//  NewsTableViewController.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 7/21/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, DetailView {
    
    var news = [News]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: DetailViewDelegate?

}

extension NewsTableViewController: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        news = data.flatMap() { $0 as? News }
    }
    
}

extension NewsTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.dataManager().getAllNews(self)
        title = "News"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.scrollToRow(at: IndexPath(row: getNextUpcomingNewsRow(), section: 0), at: UITableViewScrollPosition.top, animated: false)
    }
    
}

extension NewsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as? NewsTableViewCell ?? NewsTableViewCell()
        cell.newsItem = news[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        news[indexPath.row].open()
    }
    
}

extension NewsTableViewController {
    func getNextUpcomingNewsRow() -> Int {
        if let nextNews = delegate?.dataManager().getNextUpcomingNews() as News? {
            return news.index(of: nextNews) ?? 0
        } else {
            return 0
        }
    }
}
