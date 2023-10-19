//
//  CustomTableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by JYY on 10/19/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
