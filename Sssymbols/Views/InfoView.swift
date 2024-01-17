//
//  InfoView.swift
//  Sssymbols
//
//  Created by dan on 29/11/23.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Image("Icon")
            .resizable()
            .scaledToFill()
            .frame(width: 90, height: 90)
            Text("Sssymbols!")
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .padding(.top, 10)
            Text("Made by @ddvniele")
            .font(.system(size: 10))
            .foregroundStyle(.gray)
            HStack {
                Link("Project on GitHub", destination: URL(string: "https://github.com/ddvniele/Sssymbols")!)
                Spacer()
                Rectangle()
                .fill(.gray)
                .frame(width: 1, height: 10)
                Spacer()
                Link("@ddvniele on GitHub", destination: URL(string: "https://github.com/ddvniele")!)
            } // HSTACK
            .font(.system(size: 10))
            .padding(.horizontal, 40)
            .padding(.top, 10)
        } // VSTACK
        .frame(width: 300, height: 225)
    } // VAR BODY
} // STRUCT INFO VIEW

#Preview {
    InfoView()
} // PREVIEW
