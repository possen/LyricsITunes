//
//  LyricsQuery.swift
//  iTunesApp
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class LyricsQuery {
    static let baseURL = URL(string: "http://lyrics.wikia.com/")!
    
    func query(query: String, song: String) -> RESTRequest {
        let terms = query.replacingOccurrences(of: " ", with: "+")
        let songTerms = song.replacingOccurrences(of: " ", with: "+")
        
        let parameters =   ["term" : terms,
                            "func": "getSong",
                            "artist": terms,
                            "song": songTerms,
                            "fmt": "json"]
        
        return RESTNetworkRequest(baseURL: LyricsQuery.baseURL, command: "api.php", parameters: parameters)
    }
}
