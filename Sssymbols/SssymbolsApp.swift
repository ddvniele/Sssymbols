//
//  SssymbolsApp.swift
//  Sssymbols
//
//  Created by dan on 28/11/23.
//

import SwiftUI

@main
struct SssymbolsApp: App {
    
    // connecting app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup("Info", id: "infoView") {
            InfoView()
        } // WINDOW GROUP
        .windowResizability(.contentSize)
    } // VAR BODY
} // STRUCT SSSYMBOLS APP

// MARK: App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // close app info window at launch
        NSApplication.shared.windows.last!.close()
        
        // menu view
        let menuView = MenuView()
        
        // creating popover
        popOver.behavior = .transient
        popOver.animates = true
        
        // setting empty view controller and view as a swiftui view with hosting controller
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
        
        // making view as main view
        popOver.contentViewController?.view.window?.makeKey()
        
        // creating status bar button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: "tray.full", accessibilityDescription: nil)
            menuButton.action = #selector(MenuButtonToggle)
        } // IF LET
        
    } // FUNC APPLICATION DID FINISH LAUNCHING
    
    // menu button action
    @objc func MenuButtonToggle(sender: AnyObject) {
        // for safer side
        if popOver.isShown {
            popOver.performClose(sender)
        } else {
            // showing popover
            if let menuButton = statusItem?.button {
                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
            } // IF LET
        } // IF ELSE
    } // OBJC FUNC MENU BUTTON TOGGLE
} // CLASS APP DELEGATE
