//
//  CarouselViewDelegate.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 26/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import Foundation

public protocol CarouselViewDataSource: AnyObject {
    
    /// Defines the number of items which will be presented on Carousel View.
    ///
    /// - Parameter carouselView: DataSource's CarouselView
    /// - Returns: The number of items.
    func numberOfItems(inCarouselView carouselView: CarouselView) -> Int
    
    /// This function will call the equivalent function of UICollectionViewDataSource. Use it as if you were using a UICollectionView.
    ///
    /// - Parameters:
    ///   - carouselView: CarouselView requesting the cell.
    ///   - index: Int that speciefies the item's location.
    /// - Returns: A configured CarouselViewCell
    func carouselView(_ carouselView: CarouselView, cellForItemAt index: Int) -> CarouselViewCell
}
