import Foundation

final class SongsManager: ObservableObject {
    
    @Published
    private(set) var songs: [SongViewModel] = []
    private var songModels: [Song] = []
    private let service: SongsService
    
    init(service: SongsService) {
        self.service = service
    }
    
    func getSongs(for url: String, onError: @escaping () -> Void) {
        service.getSongs(for: url, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(songModels):
                self.songModels = songModels
                self.songs = self.getViewModels(for: songModels)
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
}
