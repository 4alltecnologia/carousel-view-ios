//
//  CarouselViewDelegate.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 26/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import Foundation

public protocol CarouselViewDataSource: AnyObject {
    
    /// Register your UICollectionViewCell nibs.
    ///
    /// - Parameter collectionView: UICollectionView to register cells.
    func registerCells(_ collectionView: UICollectionView)
    
    /// Defines the number of items which will be presented on Carousel View.
    ///
    /// - Returns: The number of items.
    func numberOfItems() -> Int
    
    /// This function will call the equivalent function of UICollectionViewDataSource. Use it as if you were using a UICollectionView.
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView requesting the cell.
    ///   - indexPath: IndexPath that speciefies the item's location.
    /// - Returns: A configured UICollectionViewCell
    func carouselView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
