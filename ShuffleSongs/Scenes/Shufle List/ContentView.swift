//
//  ContentView.swift
//  ShuffleSongs
//
//  Created by Leonel Menezes on 01/12/19.
//  Copyright © 2019 Leonel Menezes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var songs: [SongViewModel] = [
        SongViewModel(id: 0,
                      photoUrl: "https://animystic.com.br/wp-content/uploads/2019/05/gohan_0.jpg",
                      title: "Chala Head'Chala",
                      artist: "Dragon Ball")
    ]
   
    var body: some View {
        NavigationView {
            List(songs) { song in
                SongCell(songViewModel: song)
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
