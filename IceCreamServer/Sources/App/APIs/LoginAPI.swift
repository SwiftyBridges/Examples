//
//  LoginAPI.swift
//  LoginAPI
//
//  Created by Stephen Kockentiedt on 15.09.21.
//

import Fluent
import SwiftyBridges
import Vapor

/// Allows the user to log in and to register an account
struct LoginAPI: APIDefinition {
    var request: Request
    
    public func hello(_ name: String) -> String {
        "Hello, \(name)!"
    }
    
    public func registerUser(username: String, password: String, confirmPassword: String) throws -> EventLoopFuture<String> {
        guard !username.isEmpty else {
            throw Abort(.badRequest, reason: "The username must contain at least 1 character")
        }
        
        guard password.count >= 8 else {
            throw Abort(.badRequest, reason: "The password must contain at least 8 characters")
        }
        
        guard password == confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords do not match")
        }
        
        let user = try User(
            name: username,
            passwordHash: Bcrypt.hash(password)
        )
        return user.save(on: request.db).flatMapThrowing {
            try user.generateToken()
        }.flatMap { token in
            token.save(on: request.db)
                .map { token.value }
        }
    }
    
    /// Allows the user to log in
    /// - Parameters:
    ///   - username: The username of the user
    ///   - password: The password of the user
    /// - Returns: A user token needed to perform subsequent API calls for this user
    public func logIn(username: String, password: String) throws -> EventLoopFuture<String> {
        User.query(on: request.db)
            .filter(\.$name == username)
            .first()
            .flatMapThrowing { foundUser -> UserToken in
                guard
                    let user = foundUser,
                    try user.verify(password: password)
                else {
                    throw Abort(.unauthorized)
                }
                return try user.generateToken()
            }.flatMap { token in
                token.save(on: request.db)
                    .map { token.value }
            }
    }
}
