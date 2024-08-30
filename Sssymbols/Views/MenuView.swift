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
    @StateObject var sfsymbols = SFSymbols()
    
    // windows control
    @Environment(\.openWindow) var openWindow
    
    // SF Symbols 5 or 6
    @AppStorage("SFSYMBOLS_5_OR_6") var sfsymbols5or6 = 5
    
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
    
    // clipboard text
    @State var clipboardText: String = ""
    
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
                    if sfsymbols5or6 == 5 {
                        searchedSymbols = sfsymbols.allSymbols5.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } else if sfsymbols5or6 == 6 {
                        searchedSymbols = sfsymbols.allSymbols6.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                    } // IF ELSE
                } // ON CHANGE
                .frame(width: 160)
                
                Spacer()
                
                Menu(content: {
                    
                    Button("Info") {
                        openWindow(id: "infoView")
                    } // BUTTON
                    .keyboardShortcut("i")
                    
                    Divider()
                    
                    Menu(content: {
                        Button(action: {
                            sfsymbols5or6 = 6
                        }, label: {
                            HStack {
                                Text("SF Symbols 6 BETA")
                                if sfsymbols5or6 == 6 {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                } // IF
                            } // HSTACK
                        }) // BUTTON + label
                        Button(action: {
                            sfsymbols5or6 = 5
                        }, label: {
                            HStack {
                                Text("SF Symbols 5 (default)")
                                if sfsymbols5or6 == 5 {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                } // IF
                            } // HSTACK
                        }) // BUTTON + label
                    }, label: {
                        Text("SF Symbols version")
                    }) // MENU + label
                    
                    LaunchAtLogin.Toggle("Launch at login")
                    
                    Divider()
                    
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    } // BUTTON
                    .keyboardShortcut("q")
                }, label: {
                    Image(systemName: "gear")
                }) // MENU + label
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .frame(width: 15, height: 15)
            } // HSTACK
            .padding(.top, 15)
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    if searchText == "" {
                        ForEach(sfsymbols5or6 == 5 ? sfsymbols.allSymbols5 : sfsymbols.allSymbols6, id: \.self) { symbol in
                            ZStack {
                                if clipboardText == symbol {
                                    Text("Copied!")
                                    .font(.system(size: 10))
                                } else {
                                    Image(systemName: symbol)
                                    .font(.system(size: 20))
                                } // IF ELSE
                                
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundStyle(.gray)
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
                                    Button("Copy SwiftUI implementation") {
                                        sfsymbols.stringToClipboard(text: "Image(systemName: \(symbol))")
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
                                .foregroundStyle(.gray)
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
                                    Button("Copy SwiftUI implementation") {
                                        sfsymbols.stringToClipboard(text: "Image(systemName: \(symbol))")
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
    } // VAR BODY
} // STRUCT MENU VIEW

#Preview {
    MenuView()
} // PREVIEW
