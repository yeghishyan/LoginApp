//
//  SnappingCollectionViewLayout.swift
//

import UIKit

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)}
//        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//
//        let itemWidth = collectionView.frame.width*2/3
//        let itemSpace = itemWidth + minimumInteritemSpacing
//        var pageNumber = round(collectionView.contentOffset.x/itemSpace)
//
//        if velocity.x > 0 { pageNumber += 1 }
//        if velocity.x < 0 { pageNumber -= 1 }
//
//        let nearestPageOffset = pageNumber*itemSpace
//        return CGPoint(x: nearestPageOffset, y: parent.y)
//    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let nextX: CGFloat
        if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
            nextX = proposedContentOffset.x
        } else {
            nextX = collectionView.contentOffset.x + (velocity.x > 0 ? collectionView.bounds.size.width: -collectionView.bounds.size.width)
        }
        
        let targetRect = CGRect(x: nextX, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        var offsetAdjust = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach ({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset-horizontalOffset)) < fabsf(Float(offsetAdjust)) {
                offsetAdjust = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjust, y: proposedContentOffset.y)
    }

}
