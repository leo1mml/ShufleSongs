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
        var randomizedSongs = songModels
        for (index, song) in songModels.enumerated() {
            let isLastItem = index == songModels.count - 1
            if isLastItem {
                break
            }
            var visitedIndexes = Set<Int>()
            let availableIndexesAmount = songModels.count - (index + 1)
            var randomElement: (index: Int, song: Song)
            var hasInvalidElement: Bool = false
            repeat {
                randomElement = getRandomElement(of: randomizedSongs, minimumPosition: index + 1)
                visitedIndexes.insert(randomElement.index)
                let isDifferentFromPreviousOne = index == 0 ? false : randomizedSongs[index - 1].artistName != randomElement.song.artistName
                let isTheSameArtist = song.artistName == randomElement.song.artistName
                let hasVisitedAllPossibleIndexes = (visitedIndexes.count < availableIndexesAmount)
                hasInvalidElement = hasVisitedAllPossibleIndexes && (!isDifferentFromPreviousOne || isTheSameArtist)
            } while hasInvalidElement
            
            swap(array: &randomizedSongs, firstPosition: index, secondPosition: randomElement.index)
        }
        self.songModels = randomizedSongs
    }
    
    private func swap(array: inout [Song], firstPosition: Int, secondPosition: Int) {
        let tempSong = array[firstPosition]
        array[firstPosition] = array[secondPosition]
        array[secondPosition] = tempSong
    }
    
    private func getRandomElement(of songs: [Song], minimumPosition: Int) -> (song: Song, index: Int) {
        let maximumIndex = (songs.count-1)
        let randomIndex = Int.random(in: minimumPosition...maximumIndex)
        return (song: songs[randomIndex], index: randomIndex)
    }
}
