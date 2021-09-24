import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("users") { req -> EventLoopFuture<UserToken> in
        try CreateUserData.validate(content: req)
        let create = try req.content.decode(CreateUserData.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            passwordHash: Bcrypt.hash(create.password)
        )
        return user.save(on: req.db).flatMapThrowing {
            try user.generateToken()
        }.flatMap { token in
            token.save(on: req.db)
                .map { token }
        }
    }
    
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    let tokenProtected = app
        .grouped(UserToken.authenticator())
        .grouped(User.guardMiddleware())
    
    try tokenProtected.register(collection: IceCreamController())
    
    app.post("api") { req -> EventLoopFuture<Response> in
        apiRouter.handle(req)
    }
}
