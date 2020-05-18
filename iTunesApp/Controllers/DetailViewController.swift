//
//  DetailViewController.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var lyrics: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var album: UILabel!
    var model: ITunesModel.Result?
    var query = LyricsQuery()
    let store = LyricsStore()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model = model else {
            return
        }
        artist.text = model.artistName ?? "No artist"
        song.text = model.trackName ?? "No song name"
        album.text = model.collectionName ?? "No album name"
        query.query(query: model.artistName ?? "", song: model.trackName ?? "").send { result in
            switch result {
            case .success(let data):
                self.process(data)
            case .error(let error):
                print(error)
                ErrorAlertController.displayError(error, sourceView: self.scrollView!, presentingController: self)
            }
        }
    }
    
    func process(_ data: Data) {
        let result = store.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let model):
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width,
                                                     height: self.scrollView.contentSize.height)
                self.lyrics.adjustsFontSizeToFitWidth = true
                self.lyrics.minimumScaleFactor = 4
                self.lyrics.text = model.lyrics
            case .error(let error):
                print(error)
                ErrorAlertController.displayError(error, sourceView: self.scrollView!, presentingController: self)
            }
        }
    }
}

