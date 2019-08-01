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
    
    func numberOfItems() -> Int {
        return 10
    }
    
    func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "mycell")
    }
    
    func carouselView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.rowLabel.text = "\(indexPath.row)"
        return cell
    }
}

extension ViewController: CarouselViewDelegate {
    
    func carouselView(_ collectionView: UICollectionView, didSelectItemAt index: Int) {
        print("Selected item at \(index)")
    }
}
