import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {

    // Porta (Render usa $PORT)
    if let portStr = Environment.get("PORT"), let port = Int(portStr) {
        app.http.server.configuration.port = port
    } else {
        app.http.server.configuration.port = 8080
    }

    // Postgres config
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

    let tlsRequired = Environment.get("POSTGRES_TLS") ?? "require"
    let tlsConfig: PostgresConfiguration.TLSConfiguration = (
        tlsRequired == "require"
    ) ? .require : .disable

    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                tls: tlsConfig
            ),
            maxConnectionsPerEventLoop: 10,
            connectionPoolTimeout: .seconds(10)
        ),
        as: .psql
    )

    // Migrations
    app.migrations.add(CreateUsuario())

    // Rotas
    try routes(app)
}
