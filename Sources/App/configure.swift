import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    // Porta Render
    let port = Environment.get("PORT").flatMap(Int.init) ?? 8080
    app.http.server.configuration.port = port

    // Configuração Postgres
    guard
        let hostname = Environment.get("POSTGRES_HOST"),
        let portStr = Environment.get("POSTGRES_PORT"),
        let port = Int(portStr),
        let username = Environment.get("POSTGRES_USER"),
        let password = Environment.get("POSTGRES_PASSWORD"),
        let database = Environment.get("POSTGRES_DB")
    else {
        fatalError("Missing Postgres env vars")
    }

    app.databases.use(
        .postgres(
            configuration: SQLPostgresConfiguration(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                tls: .require
            )
        ),
        as: .psql
    )

    // Migrations
    app.migrations.add(CreateUsuario())

    // Rotas
    try routes(app)
}
