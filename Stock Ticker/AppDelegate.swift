//
//  AppDelegate.swift
//  Stock Ticker
//
//  Created by Ayush on 12/07/19.
//  Copyright © 2019 Ayush. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setUpMenu();
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateText),
            userInfo: nil,
            repeats: true
        )
    }
    
    func setUpMenu() {
        let statusMenu: NSMenu = NSMenu()
        statusMenu.addItem(NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q"))
        statusBarItem.menu = statusMenu
    }
    
    @objc
    func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }

    @objc
    func updateText(_ sender: Timer) {
        guard let statusButton = statusBarItem.button else { return }
        
        var request = URLRequest(url: URL(string: "https://www.nseindia.com/homepage/Indices1.json")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                let jsonResponse = try JSONSerialization.jsonObject(with:data!, options: []) as! [String:Any]
                guard let jsonArray = jsonResponse["data"] as? [[String: Any]] else {return}
                
                guard let
                    lastPrice = jsonArray[1]["lastPrice"] as? String else { return }
                guard let
                    change = jsonArray[1]["change"] as? String else { return }
                
                DispatchQueue.main.async {
                    statusButton.title = (lastPrice + " : " + change)
                }
                
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }


}

