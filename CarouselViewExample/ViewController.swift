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
            carouselView.delegate = self
            carouselView.backgroundColor = UIColor.clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        carouselView.carouselSetup(true)
    }

}

extension ViewController: CarouselViewDelegate {
    func carouselView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.rowLabel.text = "\(indexPath.row)"
        return cell
    }
    
    func cellSize() -> CGSize {
        return CGSize(width: 210, height: 300)
    }
    
    func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "mycell")
    }
    
    func numberOfItems() -> Int {
        return 10
    }
}
