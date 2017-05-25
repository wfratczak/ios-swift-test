//
//  NoteCell.swift
//  TestApp
//
//  Created by Wojciech on 2017-05-25.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class NoteCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = Const.NoteCell.cornerRadius
        layer.masksToBounds = true
    }
}
