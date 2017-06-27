//
//  LyricsITunesTests.swift
//  LyricsITunesTests
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import XCTest

@testable import LyricsITunes

class LyricsITunesTests: XCTestCase {
    
    func testProcessLyrics() {
        let lyrics = LyricsStore()
        
        let exp = expectation(description: "create lyrics query")
        do {
            let request = try MockHTTPNetworkRequest(filename: "iTunesQuery")
            request.send { response in
                switch response {
                case .success(let data):
                    switch lyrics.process(data) {
                    case .success(let lyrics):
                        XCTAssertEqual(lyrics.lyrics, "Let\"s put a new coat of paint on this lonesome old town\nSet \"em up, we\"ll be knockin\" em [...]\"")
                        exp.fulfill()
                    case .error(let error):
                        XCTFail(error.localizedDescription)
                    }
                case .error(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        wait(for: [exp], timeout: 100)
    }
    
    func testProcessITunes() {
        let itunes = ITunesStore()
        let exp = expectation(description: "create itunes query")
        do {
            let request = try MockHTTPNetworkRequest(filename: "iTunesQuery")
            request.send { response in
                switch response {
                case .success(let data):
                    switch itunes.process(data) {
                    case .success(let tunes):
                        let result = tunes.results[0]
                        XCTAssertEqual(tunes.results.count, 50)
                        XCTAssertEqual(result.artistName, "Tom Waits")
                        XCTAssertEqual(result.trackName, "I Hope That I Don't Fall In Love With You")
                        XCTAssertEqual(result.artworkUrl100, URL(string: "http://is3.mzstatic.com/image/thumb/Music/v4/f5/08/dd/f508ddf9-bd03-f1d5-6e57-41fc0680005a/source/60x60bb.jpg")!)
                        exp.fulfill()
                    case .error(let error):
                        XCTFail(error.localizedDescription)
                    }
                case .error(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        wait(for: [exp], timeout: 100)
    }
}
