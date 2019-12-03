import Foundation

protocol SongsService {
    func getSongs(for url: String, completion: @escaping (Result<[Song], Error>) -> Void)
}
