import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import CouchDB

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    var connectionProperties: ConnectionProperties {
        Log.info("Running on MacOS - using local database")
        return ConnectionProperties(host: "localhost",
                                    port: 5984,
                                    secured: false)
    }
    var client: CouchDBClient?
    var database: Database?
    
    func postInit() throws {
        client = CouchDBClient(connectionProperties: connectionProperties)
        client?.dbExists("entries", callback: { [weak self] exists, _ in
            guard let strongSelf = self else {
                return
            }
            if exists {
                Log.info("Journal entries database located - loading...")
                strongSelf.finalizeRoutes(with: Database(connProperties: strongSelf.connectionProperties,
                                                         dbName: "entries"))
            } else {
                strongSelf.createNewDatabase()
            }
        })
    }
    
    private func finalizeRoutes(with createdDatabase: Database) {
        database = createdDatabase
        initializeMetrics(router: router)
        initializeHealthRoutes(app: self)
        initializeModelRoutes(app: self)
    }
    
    func createNewDatabase() {
        Log.info("Database does not exist - creating new database")
        client?.createDB("entries", callback: { [weak self] database, error in
            guard let strongSelf = self else {
                return
            }
            guard let database = database else {
                Log.error("Could not create new database: (\(String(describing: error?.localizedDescription))) - journal entry routes not created")
                return
            }
            strongSelf.finalizeRoutes(with: database)
        })
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
