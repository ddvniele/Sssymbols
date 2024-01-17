//
//  ContentView.swift
//  Sssymbols
//
//  Created by dan on 28/11/23.
//

import SwiftUI
import ServiceManagement

struct MenuView: View {
    
    // binding symbols class
    @StateObject var sfsymbols5 = SFSymbols5()
    
    // windows control
    @Environment(\.openWindow) var openWindow
    
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
    
    // MARK: body
    var body: some View {
        NavigationStack {
            HStack {
                Text("Sssymbols!")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                
                Spacer()
                
                TextField("Search...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: searchText) {
                    searchedSymbols = sfsymbols5.allSymbols.filter { $0.self.localizedCaseInsensitiveContains(searchText) }
                } // ON CHANGE
                
                Spacer()
                
                Menu(content: {
                    Button("Info") {
                        openWindow(id: "infoView")
                    } // BUTTON
                    .keyboardShortcut("i")
                    
                    Divider()
                    
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    } // BUTTON
                    .keyboardShortcut("q")
                }, label: {
                    Image(systemName: "ellipsis.circle")
                }) // MENU + label
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .frame(width: 15, height: 15)
            } // HSTACK
            .padding(.top, 20)
            .padding(.horizontal, 20)
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    if searchText == "" {
                        ForEach(sfsymbols5.allSymbols, id: \.self) { symbol in
                            ZStack {
                                Image(systemName: symbol)
                                .font(.system(size: 20))
                                
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundStyle(.gray)
                                .opacity(0.4)
                                .frame(width: 50, height: 50)
                            } // ZSTACK
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Copy symbol name") {
                                    sfsymbols5.stringToClipboard(text: symbol)
                                } // BUTTON
                                Divider()
                                Button("Copy SwiftUI implementation") {
                                    sfsymbols5.stringToClipboard(text: "Image(systemName: \(symbol))")
                                } // BUTTON
                            })) // CONTEXT MENU
                        } // FOR EACH
                    } else {
                        ForEach(searchedSymbols, id: \.self) { symbol in
                            ZStack {
                                Image(systemName: symbol)
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                                
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundStyle(.gray)
                                .opacity(0.4)
                                .frame(width: 50, height: 50)
                            } // ZSTACK
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Copy symbol name") {
                                    sfsymbols5.stringToClipboard(text: symbol)
                                } // BUTTON
                                Divider()
                                Button("Copy SwiftUI implementation") {
                                    sfsymbols5.stringToClipboard(text: "Image(systemName: \(symbol))")
                                } // BUTTON
                            })) // CONTEXT MENU
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
    } // VAR BODY
} // STRUCT MENU VIEW

#Preview {
    MenuView()
} // PREVIEW
