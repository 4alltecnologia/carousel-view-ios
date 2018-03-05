//
//  CarouselViewDelegate.swift
//  CarouselView
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import Foundation

@objc public protocol CarouselViewDelegate {
    
    /**
     Defines the number of rows which will be presented on Carousel View.
     
     - returns: The number of rows.
     */
    func numberOfItems() -> Int
    
    /**
     This function will call the equivalent function of UICollectionView. Use it as if you were using a collection view.
     
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath: The index path that specifies the location of the item.
     
     - returns: A configured cell object. You must not return nil from this method.
     */
    func carouselView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    /**
     Tells the delegate that the item at the specified index path was selected.
     
     The collection view calls this method when the user successfully selects an item in the collection view. It does not call this method when you programmatically set the selection.
     
     - parameter collectionView: The collection view object that is notifying you of the selection change.
     - parameter indexPath: The index path of the cell that was selected.
     */
    @objc optional func carouselView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    /**
     Tells the Collection View what size each cell will have.
     
     - returns: The size of each cell.
     */
    func cellSize() -> CGSize
    
    /**
     Register a nib file for use in creating new collection view cells.
     
     - parameter collectionView: The collection view object that will be used to register the cells.
     */
    func registerCells(_ collectionView: UICollectionView)
    
    /**
     Tells the Carousel View whether the carousel is infinite or not. Default value is false.
     
     - returns: Bool value where true is infinite.
     */
    @objc optional func infiniteCells() -> Bool
    
    /**
     Tells the Carousel View which cell is the initial cell. It's going to be ignored if the carousel is infinite. Default value is 0.
     
     - returns: The initial cell position.
     */
    @objc optional func firstCell() -> Int
    
    /**
     The tint color to be used for the current page indicator. Default color is dark gray.
     
     - returns: The tint color.
     */
    @objc optional func currentPageControlIndicatorTintColor() -> UIColor
    
    /**
     The tint color to be used for the page indicator. Default color is light gray.
     
     - returns: The tint color.
     */
    @objc optional func pageControlIndicatorTintColor() -> UIColor
    
    /**
     The size of the side cells compared to the main cell size. Default scale is 0.6.
     
     - returns: The scale of side cells.
     */
    @objc optional func sideItemScale() -> CGFloat
    
    /**
     The distance between each cell. Default distance is 20.
     
     - returns: The spacing distance.
     */
    @objc optional func sideItemSpacingDistance() -> CGFloat
}
