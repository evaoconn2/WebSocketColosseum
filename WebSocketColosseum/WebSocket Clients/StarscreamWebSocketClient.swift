//
//  StarscreamWebSocketClient.swift
//  WebSocketColosseum
//
//  Created by Evan O'Connor on 07/02/2024.
//

import Foundation
import Starscream


class StarscreamWebSocketClient: WebSocketClient {
    
    
    private weak var delegate: WebSocketClientDelegate?
    private var webSocket: WebSocket?
    
    
    required init(delegate: WebSocketClientDelegate) {
        print("Initialising \(type(of: self))")
        self.delegate = delegate
    }
    
    func connect(to url: URL) {
        let request = URLRequest(url: url)
        webSocket = WebSocket(request: request)
        webSocket!.delegate = self
        webSocket!.connect()
    }
    
    func send(text: String) {
        guard let webSocket else { return }
        
        webSocket.write(string: text, completion: { [weak self] in
            self?.delegate?.didSend(self!, text: text)
        })
    }
    
}


extension StarscreamWebSocketClient: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
            case .connected(_):
                delegate?.didConnect(self)
            
            case .disconnected(_, _):
                break
            
            case .text(let text):
                delegate?.didReceive(self, text: text)
            
            case .binary(let data):
                guard let text = String(data: data, encoding: .utf8) else { break }
                delegate?.didReceive(self, text: text)
            
            case .pong(_):
                break
            case .ping(_):
                break
            case .error(let error):
                guard let error else { break }
                delegate?.didError(self, error: error)
            
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                break
            case .peerClosed:
                break
        }
    }
    
    
}
