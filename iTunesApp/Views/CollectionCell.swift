//
//  CollectionCell.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    struct ViewData {
        let index: Int
        let result: ITunesModel.Result
    }
    
    var viewData: ViewData? {
        didSet {
            if let viewData = viewData, let thumbnailURL = viewData.result.artworkUrl100 {
                image.loadImageAtURL(thumbnailURL, index: viewData.index)
            } else {
                image.image = UIImage(named: "Placeholder")
            }
            
            title.text = viewData?.result.trackName ?? "No name"
        }
    }
}

extension CollectionCell.ViewData {
    init(model: ITunesModel.Result, index: Int) {
        self.result = model
        self.index = index
    }
}



