//
//  AppDelegate.swift
//  Server
//
//  Created by Anthony Lavado on 2019-06-26.
//  Copyright © 2019 Anthony Lavado. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
let bundle = Bundle.main
var task = Process()

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        let path = Bundle.main.path(forResource: "jellyfin", ofType: nil, inDirectory: "jellyfin")
        let ffmpegpath =  String(Bundle.main.path(forResource: "ffmpeg", ofType: nil) ?? "")

        task.launchPath = path
        task.arguments = ["--noautorunwebapp", "--ffmpeg", ffmpegpath]
        
        do {
            try  task.run()
        } catch {
            print("\(error)")
        }
        
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
      task.terminate()
    task.waitUntilExit()
        
    }
    
    @objc func launchWebUI(sender: Any?) {
        NSWorkspace.shared.open(NSURL(string: "http://localhost:8096")! as URL)
    }
   
    @objc func showLogs(sender: Any?){
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: "/Users/\(NSUserName())/.local/share/jellyfin/log")
    }

    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Launch Web UI", action: #selector(launchWebUI(sender:)), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: "Show Logs", action: #selector(showLogs(sender:)), keyEquivalent: "d"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Jellyfin Server", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
}

