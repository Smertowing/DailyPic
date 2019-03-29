//
//  DailyPicClient.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import KituraKit

enum DailyPicClientError: Error {
    case couldNotLoadModels
    case couldNotAdd(EntityModel)
    case couldNotDelete(EntityModel)
    case couldNotCreateClient
}

class DailyPicClient {
    private static var baseURL: String {
        return "http://172.20.10.4:8080"
    }
    
    static func getAll(completion: @escaping (_ models: [EntityModel]?, _ error: DailyPicClientError?) -> Void) {
        guard let client = KituraKit(baseURL: baseURL) else {
            return completion(nil, DailyPicClientError.couldNotCreateClient)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        client.get("/entries") { (entries: [EntityModel]?, error: Error?) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let _ = error {
                    return completion(nil, DailyPicClientError.couldNotLoadModels)
                }
                completion(entries?.sorted(by: {
                    $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
                }), nil)
            }
        }
    }
    
    static func add(model: EntityModel, completion: @escaping (_ model: EntityModel?, _ error: DailyPicClientError?) -> Void) {
        guard let client = KituraKit(baseURL: baseURL) else {
            return completion(nil, DailyPicClientError.couldNotCreateClient)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        client.post("/entries", data: model) { (savedEntry: EntityModel?, error: Error?) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let _ = error {
                    return completion(nil, DailyPicClientError.couldNotAdd(model))
                }
                completion(savedEntry, nil)
            }
        }
    }
    
    static func delete(model: EntityModel, completion: @escaping (_ error: DailyPicClientError?) -> Void) {
        guard let client = KituraKit(baseURL: baseURL) else {
            return completion(DailyPicClientError.couldNotCreateClient)
        }
        guard let id = model.id else {
            return completion(DailyPicClientError.couldNotDelete(model))
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        client.delete("/entries", identifier: id) { (error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let _ = error {
                    return completion(DailyPicClientError.couldNotDelete(model))
                }
                completion(nil)
            }
        }
    }
}
