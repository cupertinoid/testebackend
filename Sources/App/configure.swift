import Vapor
import Fluent
import FluentPostgresDriver
import NIOSSL

public func configure(_ app: Application) throws {
    // Porta e host (Render exige 0.0.0.0)
    let port = Environment.get("PORT").flatMap(Int.init) ?? 8080
    app.http.server.configuration.port = port
    app.http.server.configuration.hostname = "0.0.0.0"

    // Credenciais do banco (Render)
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

    // SSL context atualizado (Swift 6)
    let tlsContext = try NIOSSLContext(configuration: .makeClientConfiguration())

    // Configuração Postgres
    let dbConfig = SQLPostgresConfiguration(
        hostname: hostname,
        port: dbPort,
        username: username,
        password: password,
        database: database,
        tls: .require(tlsContext)
    )

    // Registrar banco
    app.databases.use(.postgres(configuration: dbConfig), as: .psql)

    // Registrar migrations
    app.migrations.add(CreateUsuario())

    // Registrar rotas
    try routes(app)
}
