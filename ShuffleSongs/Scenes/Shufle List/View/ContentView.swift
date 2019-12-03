import SwiftUI

struct ContentView: View {
    @ObservedObject
    var songManager: SongsManager
    let artistIds: [String]
    
    @State
    private var isShowingResults: Bool = true
    
    var body: some View {
        NavigationView {
            List(songManager.songs) { song in
                SongCell(songViewModel: song)
            }.navigationBarTitle(Text("Shuffle Songs"))
                .navigationBarItems(trailing: Text("Random").onTapGesture {
                    self.songManager.randomizeItems()
                })
        }.onAppear {
            self.songManager.getSongs(for: self.artistIds, songsPerArtist: 5, onError: {
                self.isShowingResults = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(songManager: SongsManager(service: DumbService()), artistIds: [])
            .background(Color.black)
    }
}

class DumbService: SongsService {
    func getSongs(for ids: [String], songsPerArtist: Int, completion: @escaping (Result<[Song], Error>) -> Void) {
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
