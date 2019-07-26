//
//  CarouselView.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 26/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import UIKit

let moduleBundle = Bundle(identifier: "com.fourall.CarouselView")!

public class CarouselView: UIView {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clear
            collectionView.clipsToBounds = false
            collectionView.register(UINib(nibName: "", bundle: moduleBundle), forCellWithReuseIdentifier: CarouselViewItemCollectionViewCell.reuseId)
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Variables
    public weak var dataSource: CarouselViewDataSource?
    private lazy var carouselLayout: UPCarouselFlowLayout = {
        let layout = UPCarouselFlowLayout()
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = dataSource?.sideItemScale() ?? 0.6
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: dataSource?.itemSpacingDistance() ?? 20)
        layout.itemSize = dataSource?.itemSize() ?? CGSize(width: 210, height: 300)
        return layout
    }()
    
    // MARK: - Life cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = carouselLayout
    }
    
    // MARK: - Custom methods
    /**
     This function must be called when all data that will be presented on carousel is loaded.
     
     - parameter animated: It will animate the scrolling to first cell if carousel is finite.
     */
    /// <#Description#>
    ///
    /// - Parameter animated: <#animated description#>
    public func carouselSetup(_ animated: Bool) {
        if !isInitialScroll { return }
        pageControl.numberOfPages = delegate?.numberOfItems() ?? 0
        scrollToItem(animated)
        isInitialScroll = false
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselViewItemCollectionViewCell.reuseId, for: indexPath) as? CarouselViewItemCollectionViewCell,
            let contentView = dataSource?.carouselView(self, viewForItemAt: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configure(withContentView: contentView)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CarouselView: UICollectionViewDelegate {
    
}
