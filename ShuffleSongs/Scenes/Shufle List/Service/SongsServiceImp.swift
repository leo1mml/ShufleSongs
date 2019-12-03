import Foundation

final class SongsServiceImp: SongsService {
    
    func getSongs(for ids: [String], songsPerArtist: Int, completion: @escaping (Result<[Song], Error>) -> Void) {
        
        if let url = getUrl(for: ids, songsPerArtist: songsPerArtist) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(SongsResponse.self, from: data)
                            completion(.success(response.results))
                        } catch {
                            completion(.failure(URLError(.cannotParseResponse)))
                        }
                        return
                    }
                }
            }.resume()
        }
    }
    
    private func getUrl(for artistIds: [String], songsPerArtist: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "us-central1-tw-exercicio-mobile.cloudfunctions.net"
        urlComponents.path = "/lookup"
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: artistIds.joined(separator: ",")),
            URLQueryItem(name: "limit", value: "\(songsPerArtist)")
        ]
        return urlComponents.url
    }
    
}
