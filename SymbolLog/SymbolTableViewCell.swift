//
//  SymbolTableViewCell.swift
//  SymbolLog
//
//  Created by Ji Mun on 8/25/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import UIKit

class SymbolTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mainKeywordLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
