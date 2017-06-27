//
//  AssetModel.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// Swift 4 decodable is quite nice.
enum AssetModelError: Error {
    case jsonDecodeError
}

struct  ITunesModel: Decodable {
        
    struct Result: Decodable {
        let trackName: String?
        let artistName: String?
        let collectionName: String?
        let artworkUrl100: URL?
    }
    
    let results: [Result]
    let resultCount: Int
}
