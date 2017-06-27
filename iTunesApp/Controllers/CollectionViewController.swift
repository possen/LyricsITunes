//
//  CollectionViewController.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var cellCollectionViewAdaptor: CollectionViewAdaptor!
    var cellAdaptorSection: CollectionViewAdaptorSection<CollectionCell, ITunesModel.Result>!
    var dataChangedObserverToken: NSKeyValueObservation!
    var modelStore: ITunesStore!
    
    override func viewDidLoad() {
        let frame = collectionView?.frame
        
        cellAdaptorSection = CollectionViewAdaptorSection<CollectionCell, ITunesModel.Result> (
            cellReuseIdentifier: "CollectionCell",
            cellSize: CGSize(width: frame!.width/3, height: frame!.width/3),
            items: [])
        { cell, model, index in
            cell.viewData = CollectionCell.ViewData(model: model, index: index)
        }
        
        cellCollectionViewAdaptor = CollectionViewAdaptor (
            collectionView: collectionView!,
            sections: [cellAdaptorSection]) { [unowned self] in
                self.collectionView?.reloadData()
        }
        
        dataChangedObserverToken = modelStore.observe(\ITunesStore.updated) { (object, change) in
            if let results = object.results {
                self.cellAdaptorSection?.items = results.results
            }
            self.cellCollectionViewAdaptor?.update()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destination = segue.destination as! DetailViewController
            let send = sender as! CollectionCell
            if let indexPath = collectionView?.indexPath(for: send) {
                destination.model = cellAdaptorSection.items[indexPath.row]
            }
        }
    }
}
    

