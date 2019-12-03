@testable
import ShuffleSongs

final class SongsServiceStub: SongsService {
    
    private let result: Result<[Song], Error>
    private(set) var hasCalledGetSongs = false
    
    init(result: Result<[Song], Error>) {
        self.result = result
    }
    
    func getSongs(for ids: [String], songsPerArtist: Int, completion: @escaping (Result<[Song], Error>) -> Void) {
        hasCalledGetSongs = true
        completion(result)
    }
}
