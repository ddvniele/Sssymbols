//
//  SssymbolsApp.swift
//  Sssymbols
//
//  Created by dan on 28/11/23.
//

import SwiftUI
import Combine

@main
struct SssymbolsApp: App {
    
    // connecting app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        Settings {
            // workaround for no windows on launch. not the cleanest code ever
        } // SETTINGS
    } // VAR BODY
} // STRUCT SSSYMBOLS APP

// MARK: App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var eventMonitor: Any?
    var statusItem: NSStatusItem?
    var menuWindow: MenuWindow?
    var sfsymbols = SFSymbols()
    var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let menuButton = statusItem?.button {
            menuButton.image = NSImage(systemSymbolName: sfsymbols.menuButtonSymbol, accessibilityDescription: nil)
            menuButton.action = #selector(menuButtonClicked)
            menuButton.target = self
        } // IF LET
        
        setupMenuWindow()
        
        sfsymbols.$menuButtonSymbol
        .receive(on: RunLoop.main)
        .sink { [weak self] newSymbol in
            if let button = self?.statusItem?.button {
                button.image = NSImage(systemSymbolName: newSymbol, accessibilityDescription: nil)
            } // IF LET
        } // SINK
        .store(in: &cancellables)
    } // FUNC APPLICATION DID FINISH LAUNCHING
    
    func setupMenuWindow() {
        menuWindow = MenuWindow()
        
        let menuView = MenuView().environmentObject(sfsymbols)
        let hostingView = NSHostingView(rootView: menuView)
        
        menuWindow?.setContentView(hostingView)
        menuWindow?.delegate = self
    } // FUNC SETUP MENU WINDOW
    
    @objc func menuButtonClicked() {
        guard let button = statusItem?.button, let window = menuWindow else { return }
        
        if window.isVisible {
            // close window
            if let monitor = eventMonitor {
                NSEvent.removeMonitor(monitor)
                eventMonitor = nil
            } // IF LET
            
            // animation
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.15
                window.animator().alphaValue = 0
            }) {
                window.orderOut(nil)
                window.alphaValue = 1
            } // NS ANIMATION CONTEXT
            
        } else {
            // calculate & save button position
            if let buttonWindow = button.window {
                let buttonFrame = buttonWindow.convertToScreen(button.frame)
                let windowOrigin = CGPoint(
                    x: buttonFrame.midX - (window.frame.width / 2),
                    y: buttonFrame.minY - window.frame.height - 5
                ) // LET WINDOW ORIGIN
                // Usa il nuovo metodo per salvare la posizione originale
                window.setOriginalPosition(windowOrigin)
            } // IF LET
            
            // animation
            window.alphaValue = 0
            window.makeKeyAndOrderFront(nil)
            
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                window.animator().alphaValue = 1
            }) // NS ANIMATION CONTEXT
            
            // close the view when clicking outside
            eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
                if let window = self?.menuWindow, window.isVisible {
                    // check where's the click
                    let clickLocation = event.locationInWindow
                    let windowFrame = window.frame
                    let screenLocation = NSPoint(x: clickLocation.x, y: clickLocation.y)
                    
                    if !windowFrame.contains(screenLocation) {
                        self?.closeMenu()
                    } // IF
                } // IF LET
            } // EVENT MONITOR
        } // IF ELSE
    } // OBJC FUNC MENU BUTTON CLICKED
    
    func closeMenu() {
        guard let window = menuWindow, window.isVisible else { return }
        
        // close window
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        } // IF LET
        
        // animation
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            window.animator().alphaValue = 0
        }) {
            window.orderOut(nil)
            window.alphaValue = 1
        } // NS ANIMATION CONTEXT
    } // FUNC CLOSE MENU
} // CLASS APP DELEGATE

class MenuWindow: NSWindow {
    private var hostingView: NSHostingView<AnyView>?
    private var originalPosition: CGPoint?
    private var isDragging = false
    private var dragOffset = CGPoint.zero
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 350, height: 505),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        ) // SUPER
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .popUpMenu
        self.hasShadow = true
        self.isMovableByWindowBackground = false
    } // INIT
    
    func setContentView<Content: View>(_ swiftUIView: NSHostingView<Content>) {
        // menu effect
        let visualEffect = NSVisualEffectView()
        visualEffect.material = .menu
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        
        // rounded borders
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 12
        visualEffect.layer?.masksToBounds = true
        
        // combine swiftui with the effect
        visualEffect.addSubview(swiftUIView)
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor)
        ]) // NS LAYOUT CONSTRAINT
        
        self.contentView = visualEffect
    } // FUNC SET CONTENT VIEW
    
    // save position on button click
    func setOriginalPosition(_ position: CGPoint) {
        originalPosition = position
        setFrameOrigin(position)
    } // FUNC SET ORIGINAL POSITION
    
    // restore original position
    func resetToOriginalPosition() {
        if let original = originalPosition {
            setFrameOrigin(original)
        } // IF LET
    } // FUNC RESTORE TO ORIGINAL POSITION
    
    // drag mouse event
    override func mouseDown(with event: NSEvent) {
        isDragging = true
        let windowLocation = event.locationInWindow
        let screenLocation = convertToScreen(NSRect(origin: windowLocation, size: .zero)).origin
        dragOffset = CGPoint(
            x: screenLocation.x - frame.origin.x,
            y: screenLocation.y - frame.origin.y
        ) // DRAG OFFSET
        super.mouseDown(with: event)
    } // OVERRIDE FUNC MOUSE DOWN
    
    override func mouseDragged(with event: NSEvent) {
        if isDragging {
            let screenLocation = NSEvent.mouseLocation
            let newOrigin = CGPoint(
                x: screenLocation.x - dragOffset.x,
                y: screenLocation.y - dragOffset.y
            ) // LET NEW ORIGIN
            setFrameOrigin(newOrigin)
        } // IF
        super.mouseDragged(with: event)
    } // OVERRIDE FUNC MOUSE DRAGGED
    
    override func mouseUp(with event: NSEvent) {
        isDragging = false
        super.mouseUp(with: event)
    } // OVERRIDE FUNC MOUSE UP
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
} // CLASS MENU WINDOW

extension AppDelegate: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        guard let window = menuWindow, window.isVisible else { return }
        
        // animation
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            window.animator().alphaValue = 0
        }) {
            window.orderOut(nil)
            window.alphaValue = 1
        } // NS ANIMATION CONTEXT
    } // FUNC WINDOW DID RESIGN KEY
} // EXTENSION APP DELEGATE
