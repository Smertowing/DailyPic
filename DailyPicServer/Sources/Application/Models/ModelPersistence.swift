//
//  ModelPersistence.swift
//  DailyPicServer
//
//  Created by Kiryl Holubeu on 3/24/19.
//

import Foundation
import CouchDB
import SwiftyJSON

extension EntityModel {
    class Persistence {
        static func getAll(from database: Database, callback: @escaping (_ entries: [EntityModel]?, _ error: NSError?) -> Void) {
            database.retrieveAll(includeDocuments: true) { documents, error in
                guard let documents = documents else {
                    callback(nil, error)
                    return
                }
                var entries = [EntityModel]()
                for document in documents["rows"].arrayValue {
                    let id = document["id"].stringValue
                    let picture = document["doc"]["picture"].stringValue
                    guard let date = document["doc"]["date"].dateTime else {
                        continue
                    }
                    if let entry = EntityModel(id: id, picture: picture, date: date) {
                        entries.append(entry)
                    }
                }
                callback(entries, nil)
            }
        }
        
        static func save(entry: EntityModel, to database: Database, callback: @escaping (_ entryID: String?, _ error: NSError?) -> Void) {
            getAll(from: database) { entries, error in
                guard let entries = entries else {
                    return callback(nil, error)
                }
                for newEntry in entries where entry == newEntry {
                    return callback(nil, NSError(domain: "DailyPic",
                                                 code: 400,
                                                 userInfo: ["localizedDescription": "Duplicate entry"]))
                }
                let body = JSON(["picture": entry.picture,
                                 "date": entry.date.iso8601])
                database.create(body) { id, _, _, error in
                    callback(id, error)
                }
            }
        }
        
        static func get(from database: Database, with entryID: String, callback: @escaping (_ entry: EntityModel?, _ error: NSError?) -> Void) {
            database.retrieve(entryID) { document, error in
                guard let document = document else {
                    return callback(nil, error)
                }
                guard let date = document["date"].dateTime else {
                    return callback(nil, error)
                }
                guard let entry = EntityModel(id: document["_id"].stringValue, picture: document["picture"].stringValue, date: date) else {
                    return callback(nil, error)
                }
                callback(entry, nil)
            }
        }
        
        static func delete(entryWith id: String, from database: Database, callback: @escaping (_ error: NSError?) -> Void) {
            database.retrieve(id) { document, error in
                guard let document = document else {
                    return callback(error)
                }
                let id = document["_id"].stringValue
                let revision = document["_rev"].stringValue
                database.delete(id, rev: revision, callback: { error in
                    callback(error)
                })
            }
        }
    }
}
