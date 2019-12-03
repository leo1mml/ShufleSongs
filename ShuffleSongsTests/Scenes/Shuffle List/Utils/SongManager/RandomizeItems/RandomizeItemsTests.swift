import XCTest
@testable
import ShuffleSongs

final class RandomizeItemsTests: XCTestCase {
    
    private var sut: SongsManager!
    private var serviceStub: SongsServiceStub!
    private var notRandomizedSongs: [SongViewModel]!
    
    override func setUp() {
        serviceStub = SongsServiceStub(result: .success(Song.jsonDummies()))
        sut = SongsManager(service: serviceStub)
        sut.getSongs(for: [], songsPerArtist: 0, onError: {})
        notRandomizedSongs = sut.songs
        sut.randomizeItems()
    }
    
    override func tearDown() {
        sut = nil
        serviceStub = nil
    }
    
    func testFirstItemCannotBeOnSamePlace() {
        XCTAssertTrue(notRandomizedSongs[0].artist != sut.songs[0].artist)
        XCTAssertTrue(notRandomizedSongs[0].title != sut.songs[0].title)
    }
    
    func testDoesNotContainSameArtistTwiceInARow() {
        for (index, song) in sut.songs.enumerated() {
            if index + 1 == sut.songs.count {
                continue
            }
            if song.artist == sut.songs[index + 1].artist {
                XCTFail()
            }
        }
    }
}
