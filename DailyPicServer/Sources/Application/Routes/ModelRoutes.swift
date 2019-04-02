//
//  ModelRoutes.swift
//  DailyPicServer
//
//  Created by Kiryl Holubeu on 3/24/19.
//

import Foundation
import CouchDB
import LoggerAPI
import KituraContracts

private var database: Database?

func initializeModelRoutes(app: App) {
    database = app.database
    
    app.router.get("/entries", handler: getAllEntries)
    app.router.post("/entries", handler: addEntry)
    app.router.delete("/entries", handler: deleteEntry)
    app.router.put("/entries", handler: updateEntry)
    
    Log.info("Journal entry routes created")
}

func getAllEntries(completion: @escaping ([EntityModel]?, RequestError?) -> Void) -> Void {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    EntityModel.Persistence.getAll(from: database) { entries, error in
        return completion(entries, error as? RequestError)
    }
}

func addEntry(entry: EntityModel, completion: @escaping (EntityModel?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    EntityModel.Persistence.save(entry: entry, to: database) { id, error in
        guard let id = id else {
            return completion(nil, .notAcceptable)
        }
        EntityModel.Persistence.get(from: database, with: id, callback: { newEntry, error in
            return completion(newEntry, error as? RequestError)
        })
    }
}

func deleteEntry(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else {
        return completion(.internalServerError)
    }
    EntityModel.Persistence.delete(entryWith: id, from: database) { error in
        return completion(error as? RequestError)
    }
}

func updateEntry(id: String, with entry: EntityModel, completion: @escaping (EntityModel?, RequestError?) -> Void) {
    guard let database = database else {
        return completion(nil, .internalServerError)
    }
    EntityModel.Persistence.update(entryWith: id, with: entry, from: database) { updatedEntry, error in
        return completion(updatedEntry, error as? RequestError)
    }
}
