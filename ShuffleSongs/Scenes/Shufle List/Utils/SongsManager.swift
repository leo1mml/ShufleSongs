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
                self.songModels = songModels.filter({$0.trackName != nil})
            case .failure:
                onError()
            }
        })
    }
    
    private func getViewModels(for songs: [Song]) -> [SongViewModel] {
        return songs.map { SongViewModel(id: $0.id,
                                         photoUrl: $0.artworkUrl,
                                         title: $0.trackName!,
                                         artist: $0.artistName) }
    }
    
    func randomizeItems() {
        var randomizedSongs: [Song] = []
        var artistsSongsDictionary = getDictionary(for: songModels)
        
        var artistNames: [String] = []
        repeat {
            let isFirstLoop = randomizedSongs.isEmpty
            var isCollidingElements: Bool
            repeat {
                artistNames = Array(artistsSongsDictionary.keys).shuffled()
                isCollidingElements = isFirstLoop ? false : artistNames[0] == randomizedSongs[randomizedSongs.count - 1].artistName
            } while isCollidingElements && artistsSongsDictionary.count > 1
            
            for name in artistNames {
                guard var songArray = artistsSongsDictionary[name] else { return }
                let songToAdd = songArray.removeLast()
                artistsSongsDictionary[name] = songArray
                randomizedSongs.append(songToAdd)
                if songArray.isEmpty {
                    artistsSongsDictionary.removeValue(forKey: name)
                    break
                }
            }
        } while !artistsSongsDictionary.isEmpty
        self.songModels = randomizedSongs
    }
    
    private func getDictionary(for songs: [Song]) -> [String: [Song]] {
        var artistsSongsDictionary: [String: [Song]] = [:]
        songs.forEach {
            artistsSongsDictionary[$0.artistName] = (artistsSongsDictionary[$0.artistName] ?? []) + [$0]
        }
        return artistsSongsDictionary
    }
}
