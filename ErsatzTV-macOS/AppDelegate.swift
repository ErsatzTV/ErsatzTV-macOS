//
//  AppDelegate.swift
//  Server
//
//  Created by Anthony Lavado on 2019-06-26.
//  Copyright © 2019 Anthony Lavado. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let bundle = Bundle.main
  var task = Process()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
    }

    constructMenu()

    do {
      task.launchPath = Bundle.main.path(forAuxiliaryExecutable: "ErsatzTV")
      try task.run()
    } catch {
      // TODO: Add system dialog and stop here. Provide instructions at a link.
      NSLog("Could not launch ErsatzTV. Reason: \(error)")
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    task.terminate()
    task.waitUntilExit()
  }

  @objc func launchWebUI(sender: Any?) {
    let portString = ProcessInfo.processInfo.environment["ETV_UI_PORT"]
    NSLog("Port string is \(portString ?? "null")")
    let port = Int(portString ?? "") ?? 8409
    let url = "http://localhost:\(port)"
    NSWorkspace.shared.open(NSURL(string: url)! as URL)
  }

  @objc func showLogs(sender: Any?) {
    NSWorkspace.shared.selectFile(
      nil,
      inFileViewerRootedAtPath: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/Library/Application Support/ersatztv/logs").path)
  }

  func constructMenu() {
    let menu = NSMenu()

    menu.addItem(
      NSMenuItem(
        title: "Launch Web UI", action: #selector(launchWebUI(sender:)), keyEquivalent: "l"))
    menu.addItem(
      NSMenuItem(title: "Show Logs", action: #selector(showLogs(sender:)), keyEquivalent: "d"))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(
      NSMenuItem(
        title: "Quit ErsatzTV", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    statusItem.menu = menu
  }
}
