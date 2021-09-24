import Fluent
import FluentSQLiteDriver
import SwiftyBridges
import Vapor

let apiRouter = APIRouter()

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateFlavors())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(UserToken.AddExpirationDate())
    
    apiRouter.register(LoginAPI.self)
    apiRouter.register(IceCreamAPI.self)
    apiRouter.register(AlternativeIceCreamAPI.self)

    // register routes
    try routes(app)
}
