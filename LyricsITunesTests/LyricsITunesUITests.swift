//
//  LyricsITunesUITests.swift
//  LyricsITunesTests
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
import XCTest

@testable import LyricsITunes

class LyricsITunesUITests: XCTestCase {
    
    func testDetailViewController() {
        let exp = expectation(description: "Lyrics")
        let sut = DetailViewController()
        
        sut.query = LyricsQueryMock()
        let q = sut.query.query(query: "Tom Waits", song: "I Hope That I Don't Fall In Love With You")
        q.send { result in
            _ = sut.view
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20)
    }
    
    func testCollectionViewController() {
        let exp = expectation(description: "Collectoin")
        
        let sut = BaseViewController(coder: NSCoder())
        
        sut?.query = ITunesQueryMock()
        let q = sut?.query.query(query: "Tom Waits", limit:50)
        q?.send { result in
            _ = sut?.view
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20)
        
    }
}
