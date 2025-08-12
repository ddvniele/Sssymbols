//
//  InfoView.swift
//  Sssymbols
//
//  Created by dan on 29/11/23.
//

import SwiftUI

struct InfoView: View {
    
    // body
    var body: some View {
        VStack {
            HStack {
                Image("Icon")
                .resizable()
                .frame(width: 90, height: 90)
                
                VStack {
                    Text("Sssymbols!")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("open source with ❤️")
                    .font(.system(size: 12.5, weight: .regular, design: .rounded))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Link("Project on GitHub", destination: URL(string: "https://github.com/ddvniele/Sssymbols-macOS")!)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } // VSTACK
                .padding(.leading, 15)
            } // HSTACK
            .padding(.leading, 25)
            
            HStack {
                Image("ddvniele")
                .resizable()
                .frame(width: 90, height: 90)
                
                VStack {
                    Text("Dan ツ")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("@ddvniele")
                    .font(.system(size: 12.5, weight: .regular, design: .rounded))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Link("@ddvniele on GitHub", destination: URL(string: "https://github.com/ddvniele")!)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } // VSTACK
                .padding(.leading, 15)
            } // HSTACK
            .padding(.leading, 25)
            .padding(.top, 30)
            
            HStack {
                Image("qr")
                .resizable()
                .frame(width: 90, height: 90)
                
                VStack {
                    Text("New iOS app!")
                    .font(.system(size: 25, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Scan the QR code or click here ↓")
                    .font(.system(size: 12.5, weight: .regular, design: .rounded))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Link("Download for iPhone", destination: URL(string: "https://github.com/ddvniele/Sssymbols-iOS")!)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } // VSTACK
                .padding(.leading, 15)
            } // HSTACK
            .padding(.leading, 25)
            .padding(.top, 30)
        } // VSTACK
        .frame(width: 350, height: 390)
        .overlay(
            ZStack {
                Rectangle()
                .frame(height: 1)
                .foregroundStyle(.quaternary)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 135)
                
                Rectangle()
                .frame(height: 1)
                .foregroundStyle(.quaternary)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 255)
            } // ZSTACK
        ) // OVERLAY
    } // VAR BODY
} // STRUCT INFO VIEW

#Preview {
    InfoView()
} // PREVIEW
