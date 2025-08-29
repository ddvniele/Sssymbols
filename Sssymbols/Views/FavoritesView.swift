//
//  FavoritesView.swift
//  Sssymbols
//
//  Created by Dan on 11/08/25.
//

import SwiftUI

struct FavoritesView: View {
    
    // binding environment object
    @EnvironmentObject var sfsymbols: SFSymbols
    
    // search
    @Binding var searchFavoritesText: String
    
    // lazy v grid
    let columns: [GridItem] = [
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
        GridItem(.fixed(25), spacing: 40),
    ] // LET COLUMNS
    
    // clipboard text
    @Binding var clipboardText: String
    @Binding var removedFromFavorites: String
    
    // MARK: body
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(searchFavoritesText == "" ? sfsymbols.favoritesSymbols : sfsymbols.searchedFavoritesSymbols, id: \.self) { symbol in
                    ZStack {
                        if #available(macOS 26.0, *), sfsymbols.liquidGlassToggle {
                            Circle()
                            .foregroundStyle(.tertiary)
                            .opacity(0.2)
                            .frame(width: 50, height: 50)
                            .glassEffect(.regular)
                        } else {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundStyle(.tertiary)
                            .opacity(0.2)
                            .frame(width: 50, height: 50)
                        } // IF ELSE
                        
                        if clipboardText == symbol {
                            Text("Copied!")
                            .font(.system(size: 10))
                        } else if removedFromFavorites == symbol {
                            Text("Removed!")
                            .font(.system(size: 8))
                        } else {
                            Image(systemName: symbol)
                            .font(.system(size: 20))
                        } // IF ELSE
                    } // ZSTACK
                    .transition(.opacity)
                    .help(symbol)
                    .contextMenu {
                        Section(symbol) {
                            Button(action: {
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
                            }, label: {
                                Label("Copy symbol name", systemImage: "doc.on.clipboard")
                            }) // BUTTON + label
                            
                            Divider()
                            
                            Button(action: {
                                if let index = sfsymbols.favoritesSymbols.firstIndex(of: symbol) {
                                    sfsymbols.removeFromFavorites(index: index)
                                    withAnimation {
                                        removedFromFavorites = symbol
                                        let seconds = 3.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            if removedFromFavorites == symbol {
                                                withAnimation {
                                                    removedFromFavorites = ""
                                                } // WITH ANIMATION
                                            } // IF
                                        } // DISPATCH QUEUE
                                    } // WITH ANIMATION
                                } // IF LET
                            }, label: {
                                Label("Remove from Favorites", systemImage: "star.slash.fill")
                            }) // BUTTON + label
                        } // SECTION
                    } // CONTEXT MENU
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
                } // FOR EACH
            } // LAZY V GRID
            .padding(.vertical, 20)
            .animation(.easeInOut(duration: 0.15), value: searchFavoritesText)
            .animation(.easeInOut(duration: 0.15), value: sfsymbols.favoritesSymbols)
            .animation(.easeInOut(duration: 0.15), value: sfsymbols.searchedFavoritesSymbols)
        } // SCROLL VIEW
        .frame(width: 350, height: 390)
        .overlay(
            ZStack {
                if searchFavoritesText != "" && !sfsymbols.favoritesSymbols.isEmpty && sfsymbols.searchedFavoritesSymbols.isEmpty {
                    ContentUnavailableView.search(text: searchFavoritesText)
                    .transition(.opacity)
                } else if sfsymbols.favoritesSymbols.isEmpty {
                    ContentUnavailableView("No symbols added to Favorites", systemImage: "star", description: Text("To add a symbol to Favorites, right-click on it and select Add to Favorites"))
                    .transition(.opacity)
                } // IF ELSE
            } // ZSTACK
            .animation(.easeInOut(duration: 0.15), value: searchFavoritesText)
            .animation(.easeInOut(duration: 0.15), value: sfsymbols.favoritesSymbols)
            .animation(.easeInOut(duration: 0.15), value: sfsymbols.searchedFavoritesSymbols)
        ) // OVERLAY
    } // VAR BODY
} // STRUCT FAVORITES VIEW

#Preview {
    FavoritesView(searchFavoritesText: MenuView().$searchFavoritesText, clipboardText: MenuView().$clipboardText, removedFromFavorites: MenuView().$removedFromFavorites)
    .environmentObject(SFSymbols())
} // PREVIEW
