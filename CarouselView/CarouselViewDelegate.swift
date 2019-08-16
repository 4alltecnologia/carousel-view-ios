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
    
    /// The carousel view calls this method when the user successfully selects an item in the carousel view. It does not call this method when you programmatically set the selection.
    ///
    /// - Parameters:
    ///   - carouselView: CarouselView that notifies the selection.
    ///   - index: Int for the row of the selected item.
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int)
    
    /// Tells the delegate that the current page did change.
    ///
    /// - Parameter pageIndex: Index for the new current page.
    func didChangeCurrentPage(pageIndex: Int)
}

public extension CarouselViewDelegate {
    
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int) { }
    func didChangeCurrentPage(pageIndex: Int) { }
}
