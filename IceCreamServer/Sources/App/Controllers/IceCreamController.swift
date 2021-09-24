import Fluent
import Vapor

struct IceCreamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let flavors = routes.grouped("flavors")
        flavors.get(use: index)
        flavors.post(use: create)
        flavors.group(":flavorID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[IceCreamFlavor]> {
        return IceCreamFlavor.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<IceCreamFlavor> {
        let flavor = try req.content.decode(IceCreamFlavor.self)
        return flavor.save(on: req.db).map { flavor }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return IceCreamFlavor.find(req.parameters.get("flavorID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
