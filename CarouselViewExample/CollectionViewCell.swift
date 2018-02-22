//
//  CollectionViewCell.swift
//  CarouselViewExample
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 130/2
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var rowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.cornerRadius = 6.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    }

}
