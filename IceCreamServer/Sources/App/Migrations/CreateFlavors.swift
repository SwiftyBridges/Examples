import Fluent

struct CreateFlavors: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("flavors")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("flavors").delete()
    }
}
