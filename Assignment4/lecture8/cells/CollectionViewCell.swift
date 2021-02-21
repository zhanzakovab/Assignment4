//
//  CollectionViewCell.swift
//  lecture8
//
//  Created by admin on 12.02.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    static let identifier = String(describing: CollectionViewCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
