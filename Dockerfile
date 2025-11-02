# Etapa 1 — Build
FROM swift:6.0-jammy as builder

WORKDIR /app
COPY . .

# Compila o projeto em release (melhor performance)
RUN swift build --configuration release

# Etapa 2 — Runtime
FROM ubuntu:22.04

# Instala dependências mínimas pro runtime Swift
RUN apt-get update && \
    apt-get install -y \
      libatomic1 \
      libicu-dev \
      libxml2 \
      libcurl4-openssl-dev \
      libz-dev \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /run

# Copia o binário compilado
COPY --from=builder /app/.build/release/Run .

# 🔥 Copia também as bibliotecas Swift do ambiente de build
COPY --from=builder /usr/lib/swift /usr/lib/swift

# Porta padrão
ENV PORT=8080
EXPOSE 8080

# Comando de execução
CMD ["./Run", "serve", "--env", "production"]
