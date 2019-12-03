import Foundation

protocol SongsService {
    func getSongs(for ids: [String], songsPerArtist: Int, completion: @escaping (Result<[Song], Error>) -> Void)
}
