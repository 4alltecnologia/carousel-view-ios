//
//  CarouselCell.swift
//  CarouselViewExample
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import UIKit
import CarouselView

class CarouselCell: CarouselViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 130/2
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var rowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
        layer.cornerRadius = 6
        clipsToBounds = true
        backgroundColor = .white
    }

}
