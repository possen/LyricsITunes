//
//  ITunesStore.swift
//
//  Created by Paul Ossenbruggen on 6/21/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class ITunesStore: NSObject {
    var results: ITunesModel? = nil
    @objc dynamic var updated: Bool = false // this is to work around bug in setting results.
    var kvo : NSKeyValueObservation!
    
     func process(_ data: Data) -> CompletionData<ITunesModel> {
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(ITunesModel.self, from: data)
            self.results = results
            self.updated = true
            return CompletionData.success(results)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}
