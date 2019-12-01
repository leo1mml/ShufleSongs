//
//  ContentView.swift
//  ShuffleSongs
//
//  Created by Leonel Menezes on 01/12/19.
//  Copyright © 2019 Leonel Menezes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                   Image("foto")
                       .resizable()
                       .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: ContentMode.fill)
                        .cornerRadius(10)
                        .padding()
                   VStack {
                       Text("Song Name")
                        .foregroundColor(.purple)
                       Text("Artist Name")
                        .foregroundColor(.blue)
                    }.lineSpacing(16)
                   Spacer()
                }
            }.navigationBarTitle(Text("Shuffle Songs"))
            .navigationBarItems(trailing: Text("Random"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color.black)
    }
}
