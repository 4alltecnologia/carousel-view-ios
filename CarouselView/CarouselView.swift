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
    var initialScrollDone = false
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
        self.viewContent = nib.instantiate(withOwner: self, options: nil).first as! UIView
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
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 40)
        layout.itemSize = delegate?.cellSize() ?? CGSize(width: 210, height: 300)
        collectionView.collectionViewLayout = layout
        
        pageControl.numberOfPages = delegate?.numberOfItems() ?? 0
        pageControl.currentPageIndicatorTintColor = delegate?.currentPageControlIndicatorTintColor?() ?? UIColor.darkGray
        pageControl.pageIndicatorTintColor = delegate?.pageControlIndicatorTintColor?() ?? UIColor.lightGray
        
        self.isInfinite = delegate?.infiniteCells?() ?? false
    }
    
    /**
     This function must be called within your view controller's viewDidLayoutSubviews function.
     
     - parameter animated: It will animate the scrolling to first cell if carousel is finite.
     */
    public func viewDidLayoutSubviews(_ animated: Bool) {
        if initialScrollDone { return }
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
        initialScrollDone = true
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension CarouselView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isInfinite {
            if let collectionView = scrollView as? UICollectionView {
                collectionView.visibleCells.forEach({ (col) in
                    if (col.center.x - collectionView.contentOffset.x) == self.center.x {
                        let index = collectionView.indexPath(for: col)
                        self.pageControl.currentPage = index!.row % (delegate?.numberOfItems() ?? 0)
                    }
                })
            }
        } else {
            let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            self.pageControl.currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
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