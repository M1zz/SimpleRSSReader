//
//  NewsTableViewCell.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/03.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
