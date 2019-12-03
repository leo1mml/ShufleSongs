//
//  ContentView.swift
//  ShuffleSongs
//
//  Created by Leonel Menezes on 01/12/19.
//  Copyright © 2019 Leonel Menezes. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let songsService: SongsService
    
    @State
    var songs: [SongViewModel] = [
        SongViewModel(id: 0,
                      photoUrl: "https://animystic.com.br/wp-content/uploads/2019/05/gohan_0.jpg",
                      title: "Chala Head'Chala",
                      artist: "Dragon Ball")
    ]
    
    @State
    private var isShowingResults: Bool = true
   
    var body: some View {
        NavigationView {
            List(songs) { song in
                SongCell(songViewModel: song)
            }.navigationBarTitle(Text("Shuffle Songs"))
            .navigationBarItems(trailing: Text("Random"))
        }.onAppear {
            self.getSongs()
        }
    }
    
    private func getSongs() {
        self.songsService.getSongs(for: "", completion: { result in
            switch result {
            case let .success(songsModels):
                self.songs = songsModels.map { SongViewModel(id: $0.id,
                                                             photoUrl: $0.artworkUrl,
                                                             title: $0.trackName ?? "undefined",
                                                             artist: $0.artistName) }
            case .failure:
                self.isShowingResults = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(songsService: DumbService())
            .background(Color.black)
    }
}

class DumbService: SongsService {
    func getSongs(for url: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        do {
            if let url = Bundle.main.url(forResource: "SongsData", withExtension: "json") {
                let dataJson = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(SongsResponse.self, from: dataJson)
                completion(.success(response.results.compactMap({$0})))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
