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
                
                Spacer()
                
                TextField("Search...", text: selectedTab == "All" ? $searchText : $searchFavoritesText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: searchText) {
                    sfsymbols.searchedSymbols = sfsymbols.allSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                } // ON CHANGE
                .onChange(of: searchFavoritesText) {
                    sfsymbols.searchedFavoritesSymbols = sfsymbols.favoritesSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchFavoritesText) }
                } // ON CHANGE
                .frame(width: 160)
                .disabled(selectedTab == "Info")
                
                Spacer()
                
                Menu(content: {
                    if selectedTab == "Favorites" {
                        Button("Delete all Favorites") {
                            deleteFavoritesIsPresented = true
                        } // BUTTON
                        .keyboardShortcut(.delete)
                        .disabled(sfsymbols.favoritesSymbols6.isEmpty)
                        
                        Divider()
                    } // IF
                    
                    Button("Change menu icon") {
                        newMenuIconIsPresented = true
                    } // BUTTON
                    .keyboardShortcut("♡")
                    
                    LaunchAtLogin.Toggle("Launch at login")
                    .keyboardShortcut("l")
                    
                    Divider()
                    
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
                AllSymbolsView(searchText: $searchText, clipboardText: $clipboardText, addedToFavorites: $addedToFavorites, removedFromFavorites: $removedFromFavorites)
            } else if selectedTab == "Favorites" {
                FavoritesView(searchFavoritesText: $searchFavoritesText, clipboardText: $clipboardText, removedFromFavorites: $removedFromFavorites)
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
            .disabled(!sfsymbols.allSymbols6.contains(newMenuButtonIcon))
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
