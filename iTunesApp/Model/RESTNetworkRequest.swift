//
//  RESTNetworkRequest.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

enum CompletionData<DataType> {
    case error(Error)
    case success(DataType)
}

protocol RESTRequest {
    func send(completion: @escaping (_ completion : CompletionData<Data>) -> Void)
}

class RESTNetworkRequest: RESTRequest {
    fileprivate let baseURL: URL
    fileprivate let parameters: [String: String]
    fileprivate let command: String
    
    required init(baseURL: URL, command: String, parameters: [String: String]) {
        self.baseURL = baseURL
        self.parameters = parameters
        self.command = command
    }
    
    public func send(completion: @escaping (_ completion : CompletionData<Data>) -> Void) {
        let urlData = command + urlQuery + paramString
        let url = URL(string: urlData, relativeTo: baseURL)
        if let url = url {
            makeNetworkRequest(url, completion)
        }
    }
    
    private func makeNetworkRequest(_ url: URL, _ completion: @escaping (CompletionData<Data>) -> Void) {
        let request = URLRequest(url: url)
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.processError(error)
                completion(CompletionData.error(error!))
                return
            }
            completion(CompletionData.success(data))
        }
        task.resume()
    }
    
    private var urlQuery : String {
        return "?"
    }
    
    private var paramString : String {
        // converts params from dictionary to format of &key=value
        var string = parameters.reduce("") { $0 + "&\($1.0)=\($1.1)" }
        string.removeFirst()
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    private func processError(_ error : Error?) {
        if let error = error {
            // generic error handling maybe for logging.
            print("network response error \(error)")
        }
    }
}
