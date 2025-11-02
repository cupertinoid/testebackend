import Vapor
import Fluent
import FluentPostgresDriver
import NIOSSL

public func configure(_ app: Application) throws {
    // Porta
    let port = Environment.get("PORT").flatMap(Int.init) ?? 8080
    app.http.server.configuration.port = port

    // Credenciais do Render
    guard
        let hostname = Environment.get("POSTGRES_HOST"),
        let portStr = Environment.get("POSTGRES_PORT"),
        let dbPort = Int(portStr),
        let username = Environment.get("POSTGRES_USER"),
        let password = Environment.get("POSTGRES_PASSWORD"),
        let database = Environment.get("POSTGRES_DB")
    else {
        fatalError("Missing Postgres env vars")
    }

    // SSL context
    let tlsConfig = try NIOSSLContext(configuration: .forClient())

    // Conexão com Postgres
    let dbConfig = SQLPostgresConfiguration(
        hostname: hostname,
        port: dbPort,
        username: username,
        password: password,
        database: database,
        tls: .require(tlsConfig)
    )

    app.databases.use(.postgres(configuration: dbConfig), as: .psql)

    // Migrations
    app.migrations.add(CreateUsuario())

    // Rotas
    try routes(app)
}
