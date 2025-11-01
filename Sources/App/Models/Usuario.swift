import Vapor
import Fluent

final class Usuario: Model, Content, @unchecked Sendable {
    static let schema = "usuarios"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "nome")
    var nome: String?

    @Field(key: "email")
    var email: String?

    @Field(key: "senha")
    var senha: String?

    init() {}

    init(id: Int? = nil, nome: String?, email: String?, senha: String?) {
        self.id = id
        self.nome = nome
        self.email = email
        self.senha = senha
    }
}

struct CreateUsuarioRequest: Content {
    let nome: String?
    let email: String?
    let senha: String?
}
