import Fluent
import FluentSQLiteDriver
import SwiftyBridges
import Vapor

let apiRouter = APIRouter()

// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateFlavors())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    
    apiRouter.register(LoginAPI.self)
    apiRouter.register(IceCreamAPI.self)
    apiRouter.register(AlternativeIceCreamAPI.self)

    // register routes
    try routes(app)
}
