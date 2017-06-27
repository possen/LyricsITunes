//
//  MockHTTPClient.swift
//  LyricsITunesTests
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation


@testable import LyricsITunes

class MockHTTPNetworkRequest : RESTRequest {
    let json: Data
    let iTunesStore = ITunesStore()
    
    init(filename: String) throws {
        let testBundle = Bundle(for: type(of:self))
        
        guard let resourceURL = testBundle.url(forResource: filename, withExtension: "json") else {
            json = Data()
            return
        }
    
        json = try Data(contentsOf: resourceURL)
    }
    
    func send(completion: @escaping (CompletionData<Data>) -> Void) {
        completion(CompletionData.success(json))
    }
}
