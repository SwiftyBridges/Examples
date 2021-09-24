import Fluent
import Vapor

final class IceCreamFlavor: Model, Content {
    static let schema = "flavors"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    func beforeEncode() throws {
        print("beforeEncode() was called")
    }
}
