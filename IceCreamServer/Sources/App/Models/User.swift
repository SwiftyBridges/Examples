//
//  User.swift
//  User
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "password_hash")
    var passwordHash: String

    init() { }

    init(id: UUID? = nil, name: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.passwordHash = passwordHash
    }
}

struct CreateUserData: Content {
    var name: String
    var password: String
    var confirmPassword: String
}

extension CreateUserData: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: Authenticatable {
    struct Authenticator: RequestAuthenticator {
        func authenticate(request: Request) -> EventLoopFuture<Void> {
            do {
                let data = try request.content.decode(LoginData.self)
                return User.query(on: request.db).filter(\.$name == data.username).first().flatMapThrowing { foundUser in
                    guard let user = foundUser else {
                        return
                    }
                    guard try user.verify(password: data.password) else {
                        return
                    }
                    request.auth.login(user)
                }
            } catch {
                return request.eventLoop.makeFailedFuture(error)
            }
        }
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
    
    static func authenticator() -> Authenticator {
        Authenticator()
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
