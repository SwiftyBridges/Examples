import Fluent
import Vapor

final class IceCreamFlavorModel: Model, Content {
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
    
    var asFlavor: IceCreamFlavor? {
        guard let id = id else { return nil }
        
        return IceCreamFlavor(id: id, name: name)
    }
}
