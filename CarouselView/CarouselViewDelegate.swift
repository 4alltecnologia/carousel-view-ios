//
//  CarouselViewDelegate.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 31/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import Foundation

public protocol CarouselViewDelegate: AnyObject {
    
    /// Tells the delegate that the item at the specified index was selected.
    
    /// The collection view calls this method when the user successfully selects an item in the collection view. It does not call this method when you programmatically set the selection.
    ///
    /// - Parameters:
    ///   - collectionView: UICollectionView that notifies the selection.
    ///   - index: Int for the row of the selected item.
    func carouselView(_ collectionView: UICollectionView, didSelectItemAt index: Int)
    
    /// Tells the delegate that the current page did change.
    ///
    /// - Parameter pageIndex: Index for the new current page.
    func didChangeCurrentPage(pageIndex: Int)
}

public extension CarouselViewDelegate {
    
    func carouselView(_ collectionView: UICollectionView, didSelectItemAt index: Int) { }
    func didChangeCurrentPage(pageIndex: Int) { }
}
