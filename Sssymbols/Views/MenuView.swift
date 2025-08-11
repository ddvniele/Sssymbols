//
//  ContentView.swift
//  Sssymbols
//
//  Created by dan on 28/11/23.
//

import SwiftUI
import ServiceManagement
import LaunchAtLogin

struct MenuView: View {
    
    // binding symbols class
    @EnvironmentObject var sfsymbols: SFSymbols
    
    // tab bar
    @State var selectedTab: String = "All"
    let possibleTabs: [String] = ["All", "Favorites", "Info"]
    
    // lazy v grid
    let columns: [GridItem] = [
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
    ] // LET COLUMNS
    @State var searchText: String = ""
    @State var searchedSymbols: [String] = []
    
    // animations
    @State var clipboardText: String = ""
    @State var favoritesText: String = ""
    @State var noFavoritesText: String = ""
    
    // delete favorites
    @State var deleteFavoritesIsPresented: Bool = false
    @State var favoritesId = UUID()
    
    // menu button icon
    @State var newMenuButtonIcon: String = ""
    @State var newMenuIconIsPresented: Bool = false
    
    // MARK: body
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
                
                Spacer()
                
                TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: searchText) {
                    if selectedTab == "All" {
                        searchedSymbols = sfsymbols.allSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } else if selectedTab == "Favorites" {
                        searchedSymbols = sfsymbols.favoritesSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } // IF ELSE
                } // ON CHANGE
                .onChange(of: selectedTab) {
                    if selectedTab == "All" {
                        searchedSymbols = sfsymbols.allSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } else if selectedTab == "Favorites" {
                        searchedSymbols = sfsymbols.favoritesSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } // IF ELSE
                } // ON CHANGE
                .frame(width: 160)
                .disabled(selectedTab == "Info")
                
                Spacer()
                
                Menu(content: {
                    Button("Change menu icon") {
                        newMenuIconIsPresented = true
                    } // BUTTON
                    .keyboardShortcut("♡")
                    
                    LaunchAtLogin.Toggle("Launch at login")
                    .keyboardShortcut("l")
                    
                    Divider()
                    
                    if selectedTab == "Favorites" {
                        Button("Delete all Favorites") {
                            deleteFavoritesIsPresented = true
                        } // BUTTON
                        .keyboardShortcut(.delete)
                        .disabled(sfsymbols.favoritesSymbols6.isEmpty)
                        
                        Divider()
                    } // IF
                    
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    } // BUTTON
                    .keyboardShortcut("q")
                }, label: {
                    Image(systemName: "gear")
                }) // MENU + label
                .menuStyle(.borderedButton)
                .menuIndicator(.hidden)
                .frame(width: 25, height: 15)
            } // HSTACK
            .padding(.top, 15)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            
            if selectedTab == "All" {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        if searchText == "" {
                            ForEach(sfsymbols.allSymbols6, id: \.self) { symbol in
                                ZStack {
                                    if clipboardText == symbol {
                                        Text("Copied!")
                                        .font(.system(size: 10))
                                    } else if favoritesText == symbol {
                                        Text("Added!")
                                        .font(.system(size: 10))
                                    } else if noFavoritesText == symbol {
                                        Text("Removed!")
                                        .font(.system(size: 8))
                                    } else {
                                        Image(systemName: symbol)
                                        .font(.system(size: 20))
                                    } // IF ELSE
                                    
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundStyle(.tertiary)
                                    .opacity(0.4)
                                    .frame(width: 50, height: 50)
                                } // ZSTACK
                                .contextMenu(ContextMenu(menuItems: {
                                    Section(symbol) {
                                        Button("Copy symbol name") {
                                            sfsymbols.stringToClipboard(text: symbol)
                                            withAnimation {
                                                clipboardText = symbol
                                                let seconds = 3.0
                                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                    if clipboardText == symbol {
                                                        withAnimation {
                                                            clipboardText = ""
                                                        } // WITH ANIMATION
                                                    } // IF
                                                } // DISPATCH QUEUE
                                            } // WITH ANIMATION
                                        } // BUTTON
                                        Divider()
                                        Button(sfsymbols.favoritesSymbols6.contains(symbol) ? "Remove from Favorites" : "Add to Favorites") {
                                            if sfsymbols.favoritesSymbols6.contains(symbol) {
                                                sfsymbols.favoritesSymbols6.removeAll { $0 == symbol }
                                                UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
                                                withAnimation {
                                                    noFavoritesText = symbol
                                                    let seconds = 3.0
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                        if noFavoritesText == symbol {
                                                            withAnimation {
                                                                noFavoritesText = ""
                                                            } // WITH ANIMATION
                                                        } // IF
                                                    } // DISPATCH QUEUE
                                                } // WITH ANIMATION
                                            } else {
                                                sfsymbols.favoritesSymbols6.append(symbol)
                                                UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
                                                withAnimation {
                                                    favoritesText = symbol
                                                    let seconds = 3.0
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                        if favoritesText == symbol {
                                                            withAnimation {
                                                                favoritesText = ""
                                                            } // WITH ANIMATION
                                                        } // IF
                                                    } // DISPATCH QUEUE
                                                } // WITH ANIMATION
                                            } // IF ELSE
                                        } // BUTTON
                                    } // SECTION
                                })) // CONTEXT MENU
                                .onTapGesture {
                                    sfsymbols.stringToClipboard(text: symbol)
                                    withAnimation {
                                        clipboardText = symbol
                                        let seconds = 3.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            if clipboardText == symbol {
                                                withAnimation {
                                                    clipboardText = ""
                                                } // WITH ANIMATION
                                            } // IF
                                        } // DISPATCH QUEUE
                                    } // WITH ANIMATION
                                } // ON TAP GESTURE
                                .help(symbol)
                            } // FOR EACH
                        } else {
                            ForEach(searchedSymbols, id: \.self) { symbol in
                                ZStack {
                                    if clipboardText == symbol {
                                        Text("Copied!")
                                        .font(.system(size: 10))
                                    } else if favoritesText == symbol {
                                        Text("Added!")
                                        .font(.system(size: 10))
                                    } else if noFavoritesText == symbol {
                                        Text("Removed!")
                                        .font(.system(size: 8))
                                    } else {
                                        Image(systemName: symbol)
                                        .font(.system(size: 20))
                                    } // IF ELSE
                                    
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundStyle(.tertiary)
                                    .opacity(0.4)
                                    .frame(width: 50, height: 50)
                                } // ZSTACK
                                .contextMenu(ContextMenu(menuItems: {
                                    Section(symbol) {
                                        Button("Copy symbol name") {
                                            sfsymbols.stringToClipboard(text: symbol)
                                            withAnimation {
                                                clipboardText = symbol
                                                let seconds = 3.0
                                                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                    if clipboardText == symbol {
                                                        withAnimation {
                                                            clipboardText = ""
                                                        } // WITH ANIMATION
                                                    } // IF
                                                } // DISPATCH QUEUE
                                            } // WITH ANIMATION
                                        } // BUTTON
                                        Divider()
                                        Button(sfsymbols.favoritesSymbols6.contains(symbol) ? "Remove from Favorites" : "Add to Favorites") {
                                            if sfsymbols.favoritesSymbols6.contains(symbol) {
                                                sfsymbols.favoritesSymbols6.removeAll { $0 == symbol }
                                                UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
                                                withAnimation {
                                                    noFavoritesText = symbol
                                                    let seconds = 3.0
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                        if noFavoritesText == symbol {
                                                            withAnimation {
                                                                noFavoritesText = ""
                                                            } // WITH ANIMATION
                                                        } // IF
                                                    } // DISPATCH QUEUE
                                                } // WITH ANIMATION
                                            } else {
                                                sfsymbols.favoritesSymbols6.append(symbol)
                                                UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
                                                withAnimation {
                                                    favoritesText = symbol
                                                    let seconds = 3.0
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                                        if favoritesText == symbol {
                                                            withAnimation {
                                                                favoritesText = ""
                                                            } // WITH ANIMATION
                                                        } // IF
                                                    } // DISPATCH QUEUE
                                                } // WITH ANIMATION
                                            } // IF ELSE
                                        } // BUTTON
                                    } // SECTION
                                })) // CONTEXT MENU
                                .onTapGesture {
                                    sfsymbols.stringToClipboard(text: symbol)
                                    withAnimation {
                                        clipboardText = symbol
                                        let seconds = 3.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            if clipboardText == symbol {
                                                withAnimation {
                                                    clipboardText = ""
                                                } // WITH ANIMATION
                                            } // IF
                                        } // DISPATCH QUEUE
                                    } // WITH ANIMATION
                                } // ON TAP GESTURE
                                .help(symbol)
                            } // FOR EACH
                        } // IF ELSE
                    } // LAZY V GRID
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                } // SCROLL VIEW
                .frame(height: 390)
                .overlay(
                    ZStack {
                        if searchedSymbols.isEmpty && !searchText.isEmpty {
                            ContentUnavailableView.search(text: searchText)
                        } // IF
                    } // ZSTACK
                ) // OVERLAY
            } else if selectedTab == "Favorites" {
                ZStack {
                    FavoritesView(searchText: $searchText, clipboardText: $clipboardText, searchedSymbols: $searchedSymbols)
                    .overlay(
                        ZStack {
                            if searchedSymbols.isEmpty && !searchText.isEmpty && !sfsymbols.favoritesSymbols6.isEmpty {
                                ContentUnavailableView.search(text: searchText)
                            } // IF
                        } // ZSTACK
                    ) // OVERLAY
                } // ZSTACK
                .id(favoritesId) // to force recreation of the view, need to change that
                .alert("Delete all Favorites", isPresented: $deleteFavoritesIsPresented) {
                    Button("Delete", role: .destructive) {
                        sfsymbols.favoritesSymbols6.removeAll()
                        UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
                        favoritesId = UUID() // forcing recreation of the view, need to change that
                    } // BUTTON
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete all favorites? This action cannot be undone")
                } // ALERT + message
            } else if selectedTab == "Info" {
                InfoView()
            } // IF ELSE
            
            ZStack {
                Picker("Tabs", selection: $selectedTab) {
                    ForEach(possibleTabs, id: \.self) { tab in
                        Text(tab)
                    } // FOR EACH
                } // PICKER
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal, 18)
                .padding(.bottom, 7.5)
            } // ZSTACK
            .frame(height: 35)
            
        } // NAVIGATION STACK
        .frame(width: 350)
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
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Write the name of the symbol you have chosen or paste it here")
        } // ALERT + message
    } // VAR BODY
} // STRUCT MENU VIEW

#Preview {
    MenuView()
    .environmentObject(SFSymbols())
} // PREVIEW
