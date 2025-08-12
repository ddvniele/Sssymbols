//
//  AllSymbolsView.swift
//  Sssymbols
//
//  Created by Dan on 12/08/25.
//

import SwiftUI

struct AllSymbolsView: View {
    
    // binding environment object
    @EnvironmentObject var sfsymbols: SFSymbols
    
    // search
    @Binding var searchText: String
    
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
    @Binding var addedToFavorites: String
    @Binding var removedFromFavorites: String
    
    // body
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(searchText == "" ? sfsymbols.allSymbols6 : sfsymbols.searchedSymbols, id: \.self) { symbol in
                    ZStack {
                        if clipboardText == symbol {
                            Text("Copied!")
                            .font(.system(size: 10))
                        } else if addedToFavorites == symbol {
                            Text("Added!")
                            .font(.system(size: 10))
                        } else if removedFromFavorites == symbol {
                            Text("Removed!")
                            .font(.system(size: 8))
                        } else {
                            Image(systemName: symbol)
                            .font(.system(size: 20))
                        } // IF ELSE
                        
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .foregroundStyle(.tertiary)
                        .opacity(0.2)
                        .frame(width: 50, height: 50)
                    } // ZSTACK
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
                            
                            if sfsymbols.favoritesSymbols6.contains(symbol) {
                                Button(action: {
                                    if let index = sfsymbols.favoritesSymbols6.firstIndex(of: symbol) {
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
                            } else {
                                Button(action: {
                                    sfsymbols.addToFavorites(symbol: symbol)
                                    withAnimation {
                                        addedToFavorites = symbol
                                        let seconds = 3.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            if addedToFavorites == symbol {
                                                withAnimation {
                                                    addedToFavorites = ""
                                                } // WITH ANIMATION
                                            } // IF
                                        } // DISPATCH QUEUE
                                    } // WITH ANIMATION
                                }, label: {
                                    Label("Add to Favorites", systemImage: "star.fill")
                                }) // BUTTON + label
                            } // IF ELSE
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
        } // SCROLL VIEW
        .frame(width: 350, height: 390)
        .overlay(
            ZStack {
                if searchText != "" && sfsymbols.searchedSymbols.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } // IF
            } // ZSTACK
        ) // OVERLAY
    } // VAR BODY
} // STRUCT ALL SYMBOLS VIEW

#Preview {
    AllSymbolsView(searchText: MenuView().$searchText, clipboardText: MenuView().$clipboardText, addedToFavorites: MenuView().$addedToFavorites, removedFromFavorites: MenuView().$removedFromFavorites)
    .environmentObject(SFSymbols())
} // PREVIEW
