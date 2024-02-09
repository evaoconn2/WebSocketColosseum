//
//  ViewController.swift
//  WebSocketColosseum
//
//  Created by Evan O'Connor on 07/02/2024.
//

import Cocoa


class ViewController: NSViewController {
    
    @IBOutlet var urlSessionButton: NSButton!
    @IBOutlet var urlSessionLabel: NSTextField!
    @IBOutlet var starscreamButton: NSButton!
    @IBOutlet var starscreamLabel: NSTextField!
    @IBOutlet var vaporButton: NSButton!
    @IBOutlet var vaporLabel: NSTextField!
    
    private let url = URL(string: "wss://ws.postman-echo.com/raw")!
    private var webSocketClient: WebSocketClient?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        if sender == urlSessionButton {
            webSocketClient = URLSessionWebSocketClient(delegate: self)
        }
        else if sender == starscreamButton {
            webSocketClient = StarscreamWebSocketClient(delegate: self)
        }
        else if sender == vaporButton {
            webSocketClient = VaporWebSocketClient(delegate: self)
        }
        else {
            fatalError()
        }
        
        webSocketClient!.connect(to: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.webSocketClient?.send(text: "Hello, World!")
        }
    }

}


extension ViewController: WebSocketClientDelegate {
    
    func didConnect(_ client: WebSocketClient) {
        print("\(type(of: client)) didConnect")
    }
    
    func didSend(_ client: WebSocketClient, text: String) {
        print("\(type(of: client)) didSend \"\(text)\"")
    }
    
    func didReceive(_ client: WebSocketClient, text: String) {
        print("\(type(of: client)) didReceive \"\(text)\"")
    }
    
    func didError(_ client: WebSocketClient, error: Error) {
        print("\(type(of: client)) didError \"\(error.localizedDescription)\"")
    }
    
}
