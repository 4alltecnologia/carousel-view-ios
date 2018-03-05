//
//  CarouselView.swift
//  CarouselView
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import UIKit

public class CarouselView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clear
            collectionView.clipsToBounds = false
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.isUserInteractionEnabled = false
        }
    }
    
    /**
     The object that acts as the delegate of the carousel view.
     
     The delegate must adopt the CarouselViewDelegate protocol. The carousel view maintains a weak reference to the delegate object.
     */
    public var delegate: CarouselViewDelegate?
    var isInfinite = false
    let infiniteSize = 10000000
    var isInitialScroll = true
    var viewContent: UIView!
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CarouselView", bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        self.viewContent = nibView
        self.viewContent.clipsToBounds = true
        self.viewContent.backgroundColor = UIColor.clear
        viewContent.frame = self.bounds
        viewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewContent)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        delegate?.registerCells(collectionView)
        let layout = UPCarouselFlowLayout()
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = delegate?.sideItemScale?() ?? 0.6
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: delegate?.sideItemSpacingDistance?() ?? 20)
        layout.itemSize = delegate?.cellSize() ?? CGSize(width: 210, height: 300)
        collectionView.collectionViewLayout = layout
        
        pageControl.currentPageIndicatorTintColor = delegate?.currentPageControlIndicatorTintColor?() ?? UIColor.darkGray
        pageControl.pageIndicatorTintColor = delegate?.pageControlIndicatorTintColor?() ?? UIColor.lightGray
        
        self.isInfinite = delegate?.infiniteCells?() ?? false
    }
    
    /**
     This function must be called when all data that will be presented on carousel is loaded.
     
     - parameter animated: It will animate the scrolling to first cell if carousel is finite.
     */
    public func carouselSetup(_ animated: Bool) {
        if !isInitialScroll { return }
        pageControl.numberOfPages = delegate?.numberOfItems() ?? 0
        scrollToItem(animated)
        isInitialScroll = false
    }
    
    func scrollToItem(_ animated: Bool) {
        if isInfinite {
            collectionView.layoutIfNeeded()
            let midIndexPath = IndexPath(row: infiniteSize / 2, section: 0)
            collectionView.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = 0
        } else {
            if let numOfItems = delegate?.numberOfItems(), numOfItems > 0 {
                let firstCell = delegate?.firstCell?() ?? 0
                let indexPath = IndexPath(row: (firstCell < numOfItems ? firstCell : 0), section: 0)
                collectionView.layoutIfNeeded()
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
                pageControl.currentPage = indexPath.row
            }
        }
    }
    
    func getCurrentPage() -> Int {
        guard let layout = self.collectionView.collectionViewLayout as? UPCarouselFlowLayout else { return 0 }
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? collectionView.contentOffset.x : collectionView.contentOffset.y
        
        return Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension CarouselView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: indexPath.row % (delegate?.numberOfItems() ?? 0), section: 0)
        if index.row != self.getCurrentPage() { return }
        delegate?.carouselView?(collectionView, didSelectItemAt: index)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isInfinite {
            if let collectionView = scrollView as? UICollectionView {
                collectionView.visibleCells.forEach({ (col) in
                    if (col.center.x - collectionView.contentOffset.x) == self.center.x {
                        if let index = collectionView.indexPath(for: col) {
                            self.pageControl.currentPage = index.row % (delegate?.numberOfItems() ?? 0)
                        }
                    }
                })
            }
        } else {
            self.pageControl.currentPage = self.getCurrentPage()
        }
    }
}

extension CarouselView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInfinite { return infiniteSize }
        else { return delegate?.numberOfItems() ?? 0 }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let carouselDelegate = delegate else {
            return UICollectionViewCell()
        }
        
        let index = IndexPath(row: indexPath.row % (delegate?.numberOfItems() ?? 0), section: 0)
        return carouselDelegate.carouselView(collectionView, cellForItemAt: index)
    }
}
