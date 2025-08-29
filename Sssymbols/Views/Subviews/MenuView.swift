//
//  MenuView.swift
//  Sssymbols
//
//  Created by Dan on 29/11/23.
//

import SwiftUI
import LaunchAtLogin

struct MenuView: View {
    
    // binding state object
    @EnvironmentObject var sfsymbols: SFSymbols
    
    // search
    @State var searchText: String = ""
    @State var searchFavoritesText: String = ""
    
    // tab bar
    @State var selectedTab: String = "All"
    let possibleTabs: [String] = ["All", "Favorites", "Info"]
    
    // menu icon
    @State var newMenuIconIsPresented: Bool = false
    @State var newMenuButtonIcon: String = ""
    
    // favorites
    @State var deleteFavoritesIsPresented: Bool = false
    @State var favoritesId = UUID()
    
    // clipboard text
    @State var clipboardText: String = ""
    @State var addedToFavorites: String = ""
    @State var removedFromFavorites: String = ""
    
    // body
    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Text("Sssymbols!")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    Text("by @ddvniele")
                    .font(.system(size: 12.5, weight: .light, design: .rounded))
                    .foregroundStyle(.secondary)
                } // VSTACK
                .background(.opacity(0.00000001))
                .help("Right-click to reveal hidden menu")
                .contextMenu {
                    if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.SFSymbols") {
                        Button("Open SF Symbols app") {
                            NSWorkspace.shared.open(appURL)
                        } // BUTTON
                        .keyboardShortcut("t")
                    } else if let appBetaURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.SFSymbols-beta") {
                        Button("Open SF Symbols (beta) app") {
                            NSWorkspace.shared.open(appBetaURL)
                        } // BUTTON
                        .keyboardShortcut("t")
                    } else {
                        Button("Install SF Symbols app") {
                            if let url = URL(string: "https://developer.apple.com/sf-symbols/") {
                                NSWorkspace.shared.open(url)
                            } // IF LET
                        } // BUTTON
                        .keyboardShortcut("t")
                    } // IF LET ELSE
                } // CONTEXT MENU
                
                Spacer()
                
                ZStack {
                    if #available(macOS 26, *), sfsymbols.liquidGlassToggle {
                        RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.tertiary)
                        .opacity(0.2)
                        .frame(height: 25)
                        .glassEffect(.regular)
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.tertiary)
                        .frame(height: 25)
                    } // IF ELSE
                    
                    TextField("Search...", text: selectedTab == "All" ? $searchText : $searchFavoritesText)
                    .textFieldStyle(.plain)
                    .onChange(of: searchText) {
                        sfsymbols.searchedSymbols = sfsymbols.selectedAllSymbols.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } // ON CHANGE
                    .onChange(of: searchFavoritesText) {
                        sfsymbols.searchedFavoritesSymbols = sfsymbols.favoritesSymbols.filter { $0.self.localizedCaseInsensitiveContains(searchFavoritesText) }
                    } // ON CHANGE
                    .frame(width: 140)
                    .disabled(selectedTab == "Info")
                } // ZSTACK
                .frame(width: 160)
                
                Spacer()
                
                Menu(content: {
                    if selectedTab == "Favorites" {
                        Button("Delete all Favorites") {
                            deleteFavoritesIsPresented = true
                        } // BUTTON
                        .keyboardShortcut(.delete)
                        .disabled(sfsymbols.favoritesSymbols.isEmpty)
                        
                        Divider()
                    } // IF
                    
                    Menu("Choose SF Symbols") {
                        Section(content: {
                            ForEach(sfsymbols.possibleSymbols, id: \.name) { symbols in
                                Button(action: {
                                    sfsymbols.selectedSymbols = symbols.name
                                    UserDefaults.standard.set(sfsymbols.selectedSymbols, forKey: "SELECTED_SYMBOLS")
                                }, label: {
                                    Text(symbols.name)
                                    if (sfsymbols.selectedSymbols == symbols.name) {
                                        Image(systemName: "checkmark")
                                    } // IF
                                }) // BUTTON + label
                                .disabled(!ProcessInfo.processInfo.isOperatingSystemAtLeast(symbols.version))
                            } // FOR EACH
                        }, header: {
                            Text("If you see gray options, update your macOS version")
                        }) // SECTION + header
                    } // MENU
                    .onChange(of: sfsymbols.selectedSymbols) {
                        sfsymbols.updateSelectedAllSymbols()
                    } // ON CHANGE
                    
                    Button("Change menu icon") {
                        newMenuIconIsPresented = true
                    } // BUTTON
                    .keyboardShortcut("♡")
                    
                    Toggle("Liquid Glass (macOS 26+)", isOn: $sfsymbols.liquidGlassToggle)
                    .disabled(!ProcessInfo.processInfo.isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 26, minorVersion: 0, patchVersion: 0)))
                    .onChange(of: sfsymbols.liquidGlassToggle) {
                        UserDefaults.standard.set(sfsymbols.liquidGlassToggle, forKey: "LIQUID_GLASS_TOGGLE")
                    } // ON CHANGE
                    .keyboardShortcut("✦")
                    
                    Divider()
                    
                    LaunchAtLogin.Toggle("Launch at login")
                    .keyboardShortcut("l")
                    
                    Section(content: {
                        Link("Check for updates...", destination: URL(string: "https://github.com/ddvniele/Sssymbols-macOS/releases/latest")!)
                        .keyboardShortcut("u")
                    }, header: {
                        Text("Sssymbols! macOS v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown")")
                    }) // SECTION + header
                    
                    Divider()
                    
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    } // BUTTON
                    .keyboardShortcut("q")
                }, label: {
                    ZStack {
                        if #available(macOS 26, *), sfsymbols.liquidGlassToggle {
                            Circle()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.tertiary)
                            .opacity(0.2)
                            .glassEffect(.regular)
                        } else {
                            Circle()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.tertiary)
                        } // IF ELSE
                        Image(systemName: "gear")
                    } // ZSTACK
                }) // MENU + label
                .buttonStyle(.plain)
                .menuIndicator(.hidden)
                .frame(width: 25, height: 15)
            } // HSTACK
            .padding(.top, 15)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            
            ZStack {
                if selectedTab == "All" {
                    AllSymbolsView(searchText: $searchText, clipboardText: $clipboardText, addedToFavorites: $addedToFavorites, removedFromFavorites: $removedFromFavorites)
                    .transition(.opacity)
                } else if selectedTab == "Favorites" {
                    FavoritesView(searchFavoritesText: $searchFavoritesText, clipboardText: $clipboardText, removedFromFavorites: $removedFromFavorites)
                    .id(favoritesId) // to force recreation of the view, need to change that
                    .transition(.opacity)
                    .alert("Delete all Favorites", isPresented: $deleteFavoritesIsPresented) {
                        Button("Delete", role: .destructive) {
                            sfsymbols.favoritesSymbols.removeAll()
                            UserDefaults.standard.set(sfsymbols.favoritesSymbols, forKey: "FAVORITES_SYMBOLS")
                            favoritesId = UUID() // forcing recreation of the view, need to change that
                        } // BUTTON
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to delete all favorites? This action cannot be undone")
                    } // ALERT + message
                } else if selectedTab == "Info" {
                    InfoView()
                    .transition(.opacity)
                } // IF ELSE
            } // ZSTACK
            .animation(.easeInOut(duration: 0.15), value: selectedTab)
            
            ZStack {
                if #available(macOS 26.0, *) {
                    Picker("Tabs", selection: $selectedTab) {
                        ForEach(possibleTabs, id: \.self) { tab in
                            Text(tab)
                        } // FOR EACH
                    } // PICKER
                    .pickerStyle(.palette)
                    .buttonSizing(.flexible)
                    .labelsHidden()
                    .padding(.horizontal, 18)
                    .padding(.bottom, 7.5)
                } else {
                    Picker("Tabs", selection: $selectedTab) {
                        ForEach(possibleTabs, id: \.self) { tab in
                            Text(tab)
                        } // FOR EACH
                    } // PICKER
                    .pickerStyle(.palette)
                    .labelsHidden()
                    .padding(.horizontal, 18)
                    .padding(.bottom, 7.5)
                } // IF ELSE
            } // ZSTACK
            .frame(height: 35)
        } // NAVIGATION STACK
        .frame(width: 350)
        .animation(.easeInOut(duration: 0.15), value: sfsymbols.liquidGlassToggle)
        .overlay(
            ZStack {
                Rectangle()
                .frame(height: 1)
                .foregroundStyle(.quaternary)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 71)
            } // ZSTACK
        ) // OVERLAY
        .overlay(
            ZStack {
                Rectangle()
                .frame(height: 1)
                .foregroundStyle(.quaternary)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 42)
            } // ZSTACK
        ) // OVERLAY
        .alert("Change menu icon", isPresented: $newMenuIconIsPresented) {
            TextField("Symbol name...", text: $newMenuButtonIcon)
            Button("Change") {
                sfsymbols.menuButtonSymbol = newMenuButtonIcon
                UserDefaults.standard.set(sfsymbols.menuButtonSymbol, forKey: "MENU_BUTTON_SYMBOL")
            } // BUTTON
            .disabled(!sfsymbols.selectedAllSymbols.contains(newMenuButtonIcon))
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Write the name of the symbol you have chosen or paste it here")
        } // ALERT + message
    } // VAR BODY
} // STRUCT NAV VIEW

#Preview {
    MenuView()
    .environmentObject(SFSymbols())
} // PREVIEW
