import Foundation

final class SongsManager: ObservableObject {
    
    @Published
    private(set) var songs: [SongViewModel] = []
    private var songModels: [Song] = [] {
        didSet {
            songs = getViewModels(for: self.songModels)
        }
    }
    private let service: SongsService
    
    init(service: SongsService) {
        self.service = service
    }
    
    func getSongs(for ids: [String], songsPerArtist: Int, onError: @escaping () -> Void) {
        service.getSongs(for: ids, songsPerArtist: songsPerArtist, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(songModels):
                self.songModels = songModels
            case .failure:
                onError()
            }
        })
    }
    
    private func getViewModels(for songs: [Song]) -> [SongViewModel] {
        return songs.filter({$0.trackName != nil}).map { SongViewModel(id: $0.id,
                                                                       photoUrl: $0.artworkUrl,
                                                                       title: $0.trackName!,
                                                                       artist: $0.artistName) }
    }
    
    func randomizeItems() {
        var randomizedSongs = songModels
        for (index, song) in songModels.enumerated() {
            if index == songModels.count - 1 {
                break
            }
            let randomIndex = Int.random(in: (index + 1) ... songModels.count - 1)
            let randomElement = songModels[randomIndex]
            
            let isNotLastElement = index < songModels.count
            let hasTheSameArtistNameOnTheNextItem = songModels[index + 1].artistName == song.artistName
            let randomElementHasDifferentArtist = song.artistName != randomElement.artistName
            
            if isNotLastElement && hasTheSameArtistNameOnTheNextItem && randomElementHasDifferentArtist {
                let tempSong = song
                randomizedSongs[index] = randomElement
                randomizedSongs[randomIndex] = tempSong
            }
        }
        self.songModels = randomizedSongs
    }
}
