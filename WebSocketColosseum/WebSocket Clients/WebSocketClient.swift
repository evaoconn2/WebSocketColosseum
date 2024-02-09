//
//  WebSocketClient.swift
//  WebSocketColosseum
//
//  Created by Evan O'Connor on 07/02/2024.
//

import Foundation


protocol WebSocketClient: AnyObject {
    init(delegate: WebSocketClientDelegate)
    func connect(to: URL)
    func send(text: String)
}


protocol WebSocketClientDelegate: AnyObject {
    func didConnect(_: WebSocketClient)
    func didSend(_: WebSocketClient, text: String)
    func didReceive(_: WebSocketClient, text: String)
    func didError(_: WebSocketClient, error: Error)
}
