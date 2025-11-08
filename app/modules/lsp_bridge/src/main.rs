use anyhow::Result;
use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;
use tracing::{info, error};
use tracing_subscriber;

mod lsp_manager;
mod protocol;
mod servers;

use lsp_manager::LspManager;
use protocol::handle_client_connection;

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize logging
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::INFO)
        .init();

    info!("Starting LSP Bridge Server v{}", env!("CARGO_PKG_VERSION"));

    // Create LSP manager
    let lsp_manager = LspManager::new();

    // Bind WebSocket server
    let addr = "127.0.0.1:9999";
    let listener = TcpListener::bind(addr).await?;
    info!("LSP Bridge listening on: {}", addr);

    // Accept connections
    loop {
        match listener.accept().await {
            Ok((stream, peer_addr)) => {
                info!("New client connection from: {}", peer_addr);

                let manager = lsp_manager.clone();

                tokio::spawn(async move {
                    match accept_async(stream).await {
                        Ok(ws_stream) => {
                            info!("WebSocket handshake completed for {}", peer_addr);

                            if let Err(e) = handle_client_connection(ws_stream, manager).await {
                                error!("Error handling client {}: {:?}", peer_addr, e);
                            }
                        }
                        Err(e) => {
                            error!("WebSocket handshake failed for {}: {:?}", peer_addr, e);
                        }
                    }
                });
            }
            Err(e) => {
                error!("Failed to accept connection: {:?}", e);
            }
        }
    }
}
