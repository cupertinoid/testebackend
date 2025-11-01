import Fluent

struct CreateUsuario: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("usuarios")
            .field("id", .int, .identifier(auto: true))
            .field("nome", .string)
            .field("email", .string)
            .field("senha", .string)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("usuarios").delete()
    }
}
