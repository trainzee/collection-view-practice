//
//  DinamiclySizeLayout.swift
//  CellTest
//
//  Created by Dmitry on 31.03.2023.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, _ width: CGFloat) -> CGFloat
}

class DinamiclySizeLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 3
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHight: CGFloat = 0
    
    var columnWidth: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        print("prepare start")
        print("setting variable")
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        self.columnWidth = columnWidth
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        print("Cycle of items in collectionView")
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, columnWidth) ?? 180
            let height = cellPadding * 2 + photoHeight
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            
            cache.append(attributes)
            
            contentHight = max(contentHight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        print("Cycle is done")
        print("prepare done")
        
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }//        print("visableLayoutAttributes \(visibleLayoutAttributes)")
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("layoutAttributesForItem = (index = \(indexPath)) (var = \(cache[indexPath.item]))")
        return cache[indexPath.item]
    }
    
    
    
}
