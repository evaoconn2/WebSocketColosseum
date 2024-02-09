//
//  URLSessionWebSocketClient.swift
//  WebSocketColosseum
//
//  Created by Evan O'Connor on 07/02/2024.
//

import Foundation
import Network


class URLSessionWebSocketClient: WebSocketClient {
    
    private weak var delegate: WebSocketClientDelegate?
    private var session: URLSession?
    private var task: URLSessionWebSocketTask?
    
    
    required init(delegate: WebSocketClientDelegate) {
        print("Initialising \(type(of: self))")
        self.delegate = delegate
    }
    
    func connect(to url: URL) {
        session = URLSession(configuration: .ephemeral)
        task = session!.webSocketTask(with: url)
        task!.resume()
        delegate?.didConnect(self)
        listen()
    }
    
    func send(text: String) {
        guard let task else { return }
        
        task.send(.string(text)) { [weak self, text] error in
            guard error == nil else {
                self?.delegate?.didError(self!, error: error!)
                return
            }
            self?.delegate?.didSend(self!, text: text)
        }
    }
    
    private func listen() {
        DispatchQueue.global().async { [weak self] in
            guard let task = self?.task else { return }
            task.receive(completionHandler: { [weak self] result in
                if case .failure(let error) = result {
                    self?.delegate?.didError(self!, error: error)
                    return
                }
                
                guard case .success(let message) = result else { fatalError() }
                
                switch message {
                    case .string(let text):
                        self?.delegate?.didReceive(self!, text: text)
                
                    case .data(let data):
                        guard let text = String(data: data, encoding: .utf8) else { return }
                        self?.delegate?.didReceive(self!, text: text)
                
                    @unknown default:
                        fatalError()
                }
                
                self?.listen()
            })
        }
    }
    
}
