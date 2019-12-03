import SwiftUI

struct ContentView: View {
    @ObservedObject
    var songManager: SongsManager
    
    @State
    private var isShowingResults: Bool = true
    
    var body: some View {
        NavigationView {
            List(songManager.songs) { song in
                SongCell(songViewModel: song)
            }.navigationBarTitle(Text("Shuffle Songs"))
                .navigationBarItems(trailing: Text("Random").onTapGesture {
                    print("opaa")
                })
        }.onAppear {
            self.songManager.getSongs(for: "", onError: {
                self.isShowingResults = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(songManager: SongsManager(service: DumbService()))
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
