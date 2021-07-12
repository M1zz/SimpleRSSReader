//
//  RSSItem.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/04.
//

import UIKit

struct RSSItem: Decodable {
    let title: String
    let description: String
    let pubDate: String
}
