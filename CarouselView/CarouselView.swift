//
//  CarouselView.swift
//  CarouselView
//
//  Created by Matheus Alves Alano Dias on 21/02/2018.
//  Copyright © 2018 4All. All rights reserved.
//

import UIKit

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
    
    
    @objc optional func carouselView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func cellSize() -> CGSize
    func registerCells(_ collectionView: UICollectionView)
    func configurePageControl(_ pageControl: UIPageControl)
    @objc optional func infiniteCells() -> Bool
    @objc optional func firstCell() -> Int
}

public class CarouselView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let layout = CenterCellCollectionViewFlowLayout()
            layout.itemSize = delegate?.cellSize() ?? CGSize(width: 210, height: 300)
            layout.scrollDirection = .horizontal
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.collectionViewLayout = layout
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast
            collectionView.contentInset = UIEdgeInsetsMake(0, self.frame.width/4, 0, self.frame.width/4)
            collectionView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.isUserInteractionEnabled = false
        }
    }
    
    var viewContent: UIView!
    public var delegate: CarouselViewDelegate?
    var isInfinite = false
    let infiniteSize = 10000000
    
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
        self.collectionView.backgroundColor = UIColor.clear
        viewContent.frame = self.bounds
        viewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewContent)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        delegate?.registerCells(collectionView)
        pageControl.numberOfPages = delegate?.numberOfItems() ?? 0
        delegate?.configurePageControl(pageControl)
        self.isInfinite = delegate?.infiniteCells?() ?? false
    }
    
    public func viewDidAppear() {
        if isInfinite {
            let midIndexPath = IndexPath(row: infiniteSize / 2, section: 0)
            collectionView.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = 0
        } else {
            if let numOfItems = delegate?.numberOfItems(), numOfItems > 0 {
                let firstCell = delegate?.firstCell?() ?? 0
                let indexPath = IndexPath(row: (firstCell < numOfItems ? firstCell : 0), section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                pageControl.currentPage = indexPath.row
            }
        }
    }
}

extension CarouselView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            let cells = collectionView.visibleCells
            let centerX = Float(collectionView.center.x)
            
            for cell in cells {
                var pos = cell.convert(CGPoint.zero, to: self)
                pos.x += cell.frame.size.width/2
                
                let distance = fabsf(centerX - Float(pos.x))
                let scale = 1 - (distance/centerX)*0.15
                
                cell.transform = CGAffineTransform(scaleX: CGFloat(scale) , y: CGFloat(scale))
            }
        }
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
            let pageWidth = delegate?.cellSize().width ?? 210.0
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            self.pageControl.currentPage = currentPage
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
