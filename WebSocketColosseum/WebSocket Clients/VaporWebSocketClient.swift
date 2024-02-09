//
//  VaporWebSocketClient.swift
//  WebSocketColosseum
//
//  Created by Evan O'Connor on 07/02/2024.
//

import Foundation
import WebSocketKit
import NIO


class VaporWebSocketClient: WebSocketClient {
    
    private weak var delegate: WebSocketClientDelegate?
    private var eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    private var webSocket: WebSocket?
    
    
    required init(delegate: WebSocketClientDelegate) {
        print("Initialising \(type(of: self))")
        self.delegate = delegate
    }
    
    func connect(to url: URL) {
        WebSocket.connect(to: url.absoluteString, on: eventLoop) { [weak self] ws in
            self?.delegate?.didConnect(self!)
            
            self?.webSocket = ws
            
            ws.onText { [weak self] ws, text in
                self?.delegate?.didReceive(self!, text: text)
            }
            
            ws.onBinary { ws, bytes in
                guard let text = bytes.getString(at: 0, length: bytes.readableBytes) else { fatalError() }
                self?.delegate?.didReceive(self!, text: text)
            }
        }
    }
    
    func send(text: String) {
        guard let webSocket else { return }
        webSocket.send(text)
    }
    
}
