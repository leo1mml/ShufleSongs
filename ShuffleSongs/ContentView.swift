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
                      photoUrl: "ads",
                      title: "asdfoak",
                      artist: "aosidfjaois")
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

struct SongViewModel: Identifiable {
    let id: Int
    let photoUrl: String
    let title: String
    let artist: String
}

struct SongCell: View {
    
    let songViewModel: SongViewModel
    
    var body: some View {
        HStack {
           Image("foto")
               .resizable()
               .frame(width: 80, height: 80)
                .aspectRatio(contentMode: ContentMode.fill)
                .cornerRadius(10)
                .padding()
            VStack(alignment: .leading) {
               Text("Song Name")
                .font(.title)
               Text("Artist Name")
                .font(.headline)
            }.lineSpacing(16)
           Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color.black)
    }
}
