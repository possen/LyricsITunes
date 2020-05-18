//
//  BaseViewController.swift
//
//  Created by Paul Ossenbruggen on 6/21/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var searchAdaptor : SearchAdaptor? = nil
    var query = ITunesQuery()
    let modelStore = ITunesStore()
    var collectionController: CollectionViewController!
    var detailController: DetailViewController!
    var searchController: UISearchController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        searchController = UISearchController(searchResultsController: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .never
        searchAdaptor = SearchAdaptor(searchView: searchController.searchBar, parentView: view) {
            self.performQuery(query: self.searchController.searchBar.text ?? "")
        }
        performQuery(query: "Hello")
    }
        
    func performQuery(query: String) {
        DispatchQueue.global().async {
            return self.query.query(query: query, limit:50).send { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.process(data)
                    case .error(let error):
                        print(error)
                        ErrorAlertController.displayError(error, sourceView: self.view, presentingController: self)
                    }
                }
            }
        }
    }
    
    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.modelStore.process(data)
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard data.results.count >= 1 else {
                        return
                    }
                case .error(let error):
                    ErrorAlertController.displayError(error, sourceView: self.view, presentingController: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collection" {
            collectionController = segue.destination as? CollectionViewController
            collectionController.modelStore = modelStore
        } else if segue.identifier == "detail" {
            detailController = segue.destination as? DetailViewController
            if let results = modelStore.results?.results, results.count > 0 {
                detailController.model = results[0]
            }
        }
    }
}
