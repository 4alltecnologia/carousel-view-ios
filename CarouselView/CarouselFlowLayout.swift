//
//  TranslationCarouselFlowLayout.swift
//  CarouselView
//
//  Created by Luca Saldanha Schifino on 30/07/19.
//  Copyright © 2019 4All. All rights reserved.
//

import Foundation

public enum CarouselAnimationType {
    case none
    case scale
    case translation
}

public enum CarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

open class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(_ otherState: LayoutState) -> Bool {
            return size.equalTo(otherState.size) && direction == otherState.direction
        }
    }
    
    open var sideItemScale: CGFloat?
    open var sideItemTranslation: CGFloat?
    @IBInspectable open var sideItemAlpha: CGFloat = 0.6
    @IBInspectable open var sideItemShift: CGFloat = 0.0
    open var spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: 40)
    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let currentState = LayoutState(size: collectionView.bounds.size, direction: scrollDirection)
        
        if !state.isEqual(currentState) {
            setupCollectionView()
            updateLayout()
            state = currentState
        }
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        if collectionView.decelerationRate != .fast {
            collectionView.decelerationRate = .fast
        }
    }
    
    fileprivate func updateLayout() {
        guard let collectionView = collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - itemSize.height)/2
        let xInset = (collectionSize.width - itemSize.width)/2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? itemSize.width : itemSize.height
        let scaledItemOffset = (side - side*(sideItemScale ?? 1))/2
        switch spacingMode {
        case .fixed(let spacing):
            minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ transformLayoutAttributes($0) })
    }
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }
        let isHorizontal = (scrollDirection == .horizontal)
        
        let collectionCenter = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? itemSize.width : itemSize.height) + minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let shift = (1 - ratio) * sideItemShift
        attributes.alpha = alpha
        attributes.zIndex = Int(alpha * 10)
        
        if let sideItemScale = sideItemScale {
            let scale = ratio * (1 - sideItemScale) + sideItemScale
            attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        } else if let sideItemTranslation = sideItemTranslation {
            let translation = sideItemTranslation - ratio * sideItemTranslation
            let centeredTranslation = translation - sideItemTranslation/2
            let transformY = CGAffineTransform(translationX: 0, y: centeredTranslation)
            let transformX = CGAffineTransform(translationX: centeredTranslation, y: 0)
            attributes.transform = isHorizontal ? transformY : transformX
        }
        
        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }
        
        return attributes
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal = (scrollDirection == .horizontal)
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height)/2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted {
                    abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)
                }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        } else {
            let closest = layoutAttributes.sorted {
                    abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin)
                }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
}
