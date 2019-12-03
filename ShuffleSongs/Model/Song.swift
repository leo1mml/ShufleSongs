import Foundation

struct Song: Codable {
    let id: Int
    let artistName: String
    let artworkUrl: String?
    let trackName: String?
}
