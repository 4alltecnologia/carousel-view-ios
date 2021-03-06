//
//  CarouselView.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 26/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import UIKit

public class CarouselView: UIView {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = false
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Variables
    private var viewContent: UIView!
    private var isInitialScroll = true
    /// Carousel content's data source protocol.
    public weak var dataSource: CarouselViewDataSource?
    /// Carousel content's delegate protocol.
    public weak var delegate: CarouselViewDelegate?
    /// Carousel's scroll animation type. Default: none
    public var animationType: CarouselAnimationType = .none
    /// Distance between each cell. Default: 20
    @IBInspectable public var itemSpacingDistance: CGFloat = 20
    /// Size of each cell. Default: CGSize(width: 210, height: 300)
    @IBInspectable public var itemSize: CGSize = CGSize(width: 210, height: 300)
    /// Size of the side cells compared to the main cell size. Default: 0.6
    @IBInspectable public var sideItemScale: CGFloat = 0.6
    /// Translation of the side cell compared to the main cell. Default: 20
    @IBInspectable public var sideItemTranslation: CGFloat = 20
    /// Initial cell index. Default: 0
    @IBInspectable public var firstCellIndex: Int = 0
    /// Page indicator UIColor for current page. Default: darkGray
    @IBInspectable public var currentPageIndicatorTintColor: UIColor = .darkGray
    /// Page indicator tint color. Default: lightGray
    @IBInspectable public var pageIndicatorTintColor: UIColor = .lightGray
    /// UICollectionView's Scroll direction. Default: horizontal
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    /// Hides the page control. Default: false
    @IBInspectable public var isPageControlHidden: Bool = false {
        didSet {
            pageControl.isHidden = isPageControlHidden
        }
    }
    private var pageSize: CGSize {
        guard let layout = collectionView.collectionViewLayout as? CarouselFlowLayout else { return .zero }
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    private lazy var carouselLayout: CarouselFlowLayout = {
        let layout = CarouselFlowLayout()
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = animationType == .scale ? sideItemScale : nil
        layout.sideItemTranslation = animationType == .translation ? sideItemTranslation : nil
        layout.scrollDirection = scrollDirection
        layout.spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: itemSpacingDistance)
        layout.itemSize = itemSize
        return layout
    }()
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CarouselView", bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        viewContent = nibView
        viewContent.clipsToBounds = true
        viewContent.backgroundColor = .clear
        viewContent.frame = bounds
        viewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewContent)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = carouselLayout
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
    }
    
    // MARK: - Custom methods
    
    /// This function must be called when all data that will be presented on carousel is loaded.
    ///
    /// - Parameter animated:  It will scroll animated to first cell if carousel is finite.
    public func carouselSetup(_ animated: Bool) {
        if !isInitialScroll { return }
        pageControl.numberOfPages = dataSource?.numberOfItems(inCarouselView: self) ?? 0
        scrollToItem(animated)
        isInitialScroll = false
    }
    
    /// Reload Carousel View data.
    public func reloadData() {
        collectionView.reloadData()
    }
    
    /// Register a cell to be used.
    ///
    /// - Parameters:
    ///   - nib: UINib for the cell.
    ///   - identifier: String for the cell's identifier.
    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// Dequeue reusable cell.
    ///
    /// - Parameters:
    ///   - identifier: String for the cell's identifier.
    ///   - indexPath: Cell's IndexPath.
    /// - Returns: CarouselViewCell to be reused.
    public func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> CarouselViewCell? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0)) as? CarouselViewCell
    }
    
    private func scrollToItem(_ animated: Bool) {
        if let numOfItems = dataSource?.numberOfItems(inCarouselView: self), numOfItems > 0 {
            let indexPath = IndexPath(row: (firstCellIndex < numOfItems ? firstCellIndex : 0), section: 0)
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            pageControl.currentPage = indexPath.row
        }
    }
    
    private func getCurrentPage() -> Int {
        guard let layout = collectionView.collectionViewLayout as? CarouselFlowLayout else { return 0 }
        let pageSide = (layout.scrollDirection == .horizontal) ? pageSize.width : pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? collectionView.contentOffset.x : collectionView.contentOffset.y
        return Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inCarouselView: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.carouselView(self, cellForItemAt: indexPath.row) ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension CarouselView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: indexPath.row % (dataSource?.numberOfItems(inCarouselView: self) ?? 0), section: 0)
        if index.row != self.getCurrentPage() { return }
        delegate?.carouselView(self, didSelectItemAt: indexPath.row)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = getCurrentPage()
        delegate?.didChangeCurrentPage(pageIndex: getCurrentPage())
    }
}
