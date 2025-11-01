import Vapor
import Fluent

struct UsuarioController {

    // POST /usuarios
    func create(_ req: Request) async throws -> Usuario {
        let body = try req.content.decode(CreateUsuarioRequest.self)

        // você pode fazer validações aqui (email obrigatório, etc.)
        let usuario = Usuario(
            nome: body.nome,
            email: body.email,
            senha: body.senha
        )

        try await usuario.save(on: req.db)
        return usuario
    }

    // GET /usuarios?page=1&size=20
    func list(_ req: Request) async throws -> [Usuario] {
        let page = (try? req.query.get(Int.self, at: "page")) ?? 1
        let size = (try? req.query.get(Int.self, at: "size")) ?? 20

        let limit = max(1, min(size, 100)) // limita a 100 por segurança
        let offset = (max(page, 1) - 1) * limit

        return try await Usuario.query(on: req.db)
            .range(offset..<(offset + limit))
            .all()
    }

    // GET /usuarios/search?nome=el&page=1&size=10
    func searchByName(_ req: Request) async throws -> [Usuario] {
        let searchTerm = (try? req.query.get(String.self, at: "nome")) ?? ""
        let page = (try? req.query.get(Int.self, at: "page")) ?? 1
        let size = (try? req.query.get(Int.self, at: "size")) ?? 20

        let limit = max(1, min(size, 100))
        let offset = (max(page, 1) - 1) * limit

        return try await Usuario.query(on: req.db)
            .group(.or) { group in
                group.filter(\.$nome ~~ searchTerm)
            }
            .range(offset..<(offset + limit))
            .all()
    }
}
