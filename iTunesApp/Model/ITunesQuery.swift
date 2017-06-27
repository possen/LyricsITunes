//
//  Query.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation


class ITunesQuery {
    static let baseURL = URL(string: "https://itunes.apple.com/")!
    
    func query(query: String, limit: Int) -> RESTRequest {
        let terms = query.replacingOccurrences(of: " ", with: "+")
        let parameters =   ["term" : terms,
                            "limit": "\(limit)"]
        
        return RESTNetworkRequest(baseURL: ITunesQuery.baseURL, command: "search", parameters: parameters)
    }
}
