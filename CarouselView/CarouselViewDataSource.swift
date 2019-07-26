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
    /// - Returns: The number of items.
    func numberOfItems() -> Int
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - carouselView: <#carouselView description#>
    ///   - row: <#row description#>
    /// - Returns: <#return value description#>
    func carouselView(_ carouselView: CarouselView, viewForItemAt row: Int) -> UIView
    
    /// The size of the side items compared to the main item.
    ///
    /// - Returns:  The scale of side items.
    func sideItemScale() -> CGFloat
    
    /// The distance between each item.
    ///
    /// - Returns: The spacing distance.
    func itemSpacingDistance() -> CGFloat
    
    /**
     Tells the Collection View what size each cell will have.
     
     - returns: The size of each cell.
     */
    /// Tells the Carousel View what size each item will have.
    ///
    /// - Returns: <#return value description#>
    func itemSize() -> CGSize
}

extension CarouselViewDataSource {
    
    func sideItemScale() -> CGFloat {
        return 1
    }
    
    func itemSpacing() -> CGFloat {
        return 20
    }
}
