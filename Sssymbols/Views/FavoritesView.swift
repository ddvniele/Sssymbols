//
//  FavoritesView.swift
//  Sssymbols
//
//  Created by Dan on 11/08/25.
//

import SwiftUI

struct FavoritesView: View {
    
    // binding symbols class
    @StateObject var sfsymbols = SFSymbols()
    
    let columns: [GridItem] = [
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
    ] // LET COLUMNS
    
    // bindings
    @Binding var searchText: String
    @Binding var clipboardText: String
    @Binding var searchedSymbols: [String]
    
    // MARK: body
    var body: some View {
        ZStack {
            if sfsymbols.favoritesSymbols6.isEmpty {
                ContentUnavailableView("No symbols added to Favorites", systemImage: "star", description: Text("To add a symbol to favorites, right-click on it and select Add to Favorites"))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        if searchText == "" {
                            ForEach(sfsymbols.favoritesSymbols6, id: \.self) { symbol in
                                ZStack {
                                    if clipboardText == symbol {
                                        Text("Copied!")
                                        .font(.system(size: 10))
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
                                        Button("Remove from Favorites") {
                                            sfsymbols.favoritesSymbols6.removeAll { $0 == symbol }
                                            UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
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
                                        Button("Remove from Favorites") {
                                            sfsymbols.favoritesSymbols6.removeAll { $0 == symbol }
                                            UserDefaults.standard.set(sfsymbols.favoritesSymbols6, forKey: "FAVORITES_SYMBOLS_6")
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
            } // IF ELSE
        } // ZSTACK
        .frame(width: 350, height: 390)
    } // VAR BODY
} // STRUCT FAVORITES VIEW

#Preview {
    FavoritesView(searchText: MenuView().$searchText, clipboardText: MenuView().$clipboardText, searchedSymbols: MenuView().$searchedSymbols)
} // PREVIEW
