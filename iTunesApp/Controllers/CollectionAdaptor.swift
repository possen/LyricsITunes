//
//  TubiCollectionAdaptor.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

protocol CollectionViewDataManagerDelegate : class {
    func update()
}

protocol CollectionSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var cellSize: CGSize { get }
    var itemCount : Int { get }
    func configure(cell: UICollectionViewCell, index: Int)
}

class CollectionViewAdaptorSection<Cell, Model>: CollectionSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal var items: [Model]
    internal var cellSize: CGSize
    
    init(cellReuseIdentifier: String,
         cellSize: CGSize,
         items: [Model],
         configure: @escaping ( Cell, Model, Int ) -> Void)
    {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.items = items
        self.configure = configure
        self.cellSize = cellSize
    }
    
    internal var itemCount: Int {
        return items.count
    }
    
    internal func configure(cell: UICollectionViewCell, index: Int) {
        configure(cell as! Cell, items[index], index)
    }
    
    internal var configure: ( Cell, Model, Int ) -> Void
}


class CollectionViewAdaptor: NSObject,
    CollectionViewDataManagerDelegate {
    private let collectionView: UICollectionView
    private let didChangeHandler: () -> Void
    public var sections : [CollectionSectionAdaptor]
    
    init(collectionView: UICollectionView,
         sections: [CollectionSectionAdaptor],
         didChangeHandler: @escaping () -> Void)
    {
        self.collectionView = collectionView
        self.didChangeHandler = didChangeHandler
        self.sections = sections
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    public func update() {
        DispatchQueue.main.async {
            self.didChangeHandler()
        }
    }
}

extension CollectionViewAdaptor: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        return section.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:section.cellReuseIdentifier, for: indexPath)
        section.configure(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath)
    }
}

extension CollectionViewAdaptor: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].cellSize
    }
}
extension CollectionViewAdaptor: UICollectionViewDelegate {
    
}

