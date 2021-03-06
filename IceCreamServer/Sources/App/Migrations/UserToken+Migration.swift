//
//  UserToken+Migration.swift
//  UserToken+Migration
//
//  Created by Stephen Kockentiedt on 14.09.21.
//

import Fluent

extension UserToken {
    struct Migration: Fluent.Migration {
        var name: String { "CreateUserToken" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_tokens")
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field("expiration_date", .datetime, .required, .sql(.default("2007-12-24T18:21Z")))
                .unique(on: "value")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_tokens").delete()
        }
    }
}
