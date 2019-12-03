@testable import ShuffleSongs
import Foundation

extension Song: Dummy {
    static func dummy() -> Song {
        let id = Int.random(in: 0...Int.max)
        return Song(id: id,
                    artistName: "Name \(id)",
                    artworkUrl: "url \(id)",
                    trackName: "trackName \(id)")
    }
}

extension Song {
    static func jsonDummies() -> [Song] {
        let url = Bundle.main.url(forResource: "SongsData", withExtension: "json")!
        let dataJson = try! Data(contentsOf: url)
        let response = try! JSONDecoder().decode(SongsResponse.self, from: dataJson)
        return response.results
    }
}
