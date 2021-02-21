//
//  TableViewCell.swift
//  lecture8
//
//  Created by admin on 12.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    static let identifier = String(describing: TableViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
