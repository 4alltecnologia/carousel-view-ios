//
//  ViewController.swift
//  CarouselViewExample
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import UIKit
import CarouselView

class ViewController: UIViewController {

    @IBOutlet weak var carouselView: CarouselView! {
        didSet {
            carouselView.registerNib(for: CollectionViewCell.self)
            carouselView.dataSource = self
            carouselView.delegate = self
            carouselView.backgroundColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        carouselView.carouselSetup(true)
    }
}

extension ViewController: CarouselViewDataSource {
    func numberOfItems(inCarouselView carouselView: CarouselView) -> Int {
        return 10
    }
    
    func carouselView(_ carouselView: CarouselView, cellForItemAt indexPath: IndexPath) -> CarouselViewCell {
        let cell: CollectionViewCell? = carouselView.dequeueReusableCell(for: indexPath)
        cell?.rowLabel.text = "\(indexPath.row)"
        return cell ?? CarouselViewCell()
    }
}

extension ViewController: CarouselViewDelegate {
    
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int) {
        print("Selected item at \(index)")
    }
}
