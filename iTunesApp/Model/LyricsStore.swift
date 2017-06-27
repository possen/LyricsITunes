//
//  LyricsStore.swift
//  iTunesApp
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class LyricsStore: NSObject {
    var results: LyricsModel? = nil
    @objc dynamic var updated: Bool = false // this is to work around bug in setting results.
    var kvo : NSKeyValueObservation!
    
    func process(_ data: Data) -> CompletionData<LyricsModel> {
        let decoder = JSONDecoder()
        do {
            let str = String(data: data, encoding: .utf8)!
            print(str)
            let fixStr = str.replacingOccurrences(of: "\n", with: "")
            let fix2Str = fixStr.replacingOccurrences(of: "'", with: "\"")
            let fix3Str = String(describing: fix2Str.dropFirst(7))
            print(fix3Str)
            let results = try decoder.decode(LyricsModel.self, from: (fix3Str.data(using: .utf8))! )
            self.results = results
            self.updated = true
            return CompletionData.success(results)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}
