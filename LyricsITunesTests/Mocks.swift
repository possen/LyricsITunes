//
//  Mocks.swift
//  LyricsITunesTests
//
//  Created by Paul Ossenbruggen on 6/25/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

@testable import LyricsITunes

class ITunesQueryMock: ITunesQuery {
    override func query(query: String, limit: Int) -> RESTRequest {
        return try! MockHTTPNetworkRequest(filename: "ITunesQuery")
    }
}

class LyricsQueryMock: LyricsQuery {
    override func query(query: String, song: String) -> RESTRequest {
        return try! MockHTTPNetworkRequest(filename: "Lyrics")
    }
}
