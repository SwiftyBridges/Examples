//
//  IceCreamAPI.swift
//  IceCreamAPI
//
//  Created by Stephen Kockentiedt on 17.09.21.
//

import Fluent
import Foundation
import SwiftyBridges
import Vapor

struct IceCreamAPI: APIDefinition {
    static let middlewares: [Middleware] = [
        UserToken.authenticator(),
        User.guardMiddleware(),
    ]
    
    var request: Request
    
    public func getAllFlavors() -> EventLoopFuture<[IceCreamFlavor]> {
        IceCreamFlavor.query(on: request.db).all()
    }
    
    public func add(flavorWithName flavorName: String) -> EventLoopFuture<Void> {
        let flavor = IceCreamFlavor(name: flavorName)
        return flavor.save(on: request.db)
    }
    
    public func delete(flavorWithID flavorID: UUID) -> EventLoopFuture<Void> {
        IceCreamFlavor.find(flavorID, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: request.db) }
    }
}

struct AlternativeIceCreamAPI: APIDefinition {
    static let middlewares: [Middleware] = [
        UserToken.authenticator(),
    ]
    
    var request: Request
    var user: User
    
    init(request: Request) throws {
        self.request = request
        self.user = try request.auth.require(User.self)
    }
    
    public func getAllFlavors() throws -> EventLoopFuture<[IceCreamFlavor]> {
        IceCreamFlavor.query(on: request.db).all()
    }
    
    public func add(flavorWithName flavorName: String) -> EventLoopFuture<Void> {
        let flavor = IceCreamFlavor(name: flavorName)
        return flavor.save(on: request.db)
    }
    
    public func delete(flavorWithID flavorID: UUID) -> EventLoopFuture<Void> {
        IceCreamFlavor.find(flavorID, on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: request.db) }
    }
}
