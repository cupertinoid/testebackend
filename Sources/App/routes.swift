import Vapor

func routes(_ app: Application) throws {
    let usuarioController = UsuarioController()

    // POST /usuarios
    app.post("usuarios", use: usuarioController.create)

    // GET /usuarios
    app.get("usuarios", use: usuarioController.list)

    // GET /usuarios/search
    app.get("usuarios", "search", use: usuarioController.searchByName)
}
