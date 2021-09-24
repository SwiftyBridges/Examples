import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.post("api") { req -> EventLoopFuture<Response> in
        apiRouter.handle(req)
    }
}
