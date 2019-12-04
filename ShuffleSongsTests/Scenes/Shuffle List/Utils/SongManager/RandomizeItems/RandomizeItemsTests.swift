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
    
    func testDoesNotContainSameArtistTwiceInARow() {
        for (index, song) in sut.songs.enumerated() {
            if index + 1 == sut.songs.count {
                break
            }
            if song.artist == sut.songs[index + 1].artist {
                XCTFail()
            }
        }
    }
    
    func testExautivelyIfItIsRandom() {
        for _ in 0...10 {
            sut.randomizeItems()
            testDoesNotContainSameArtistTwiceInARow()
        }
    }
    
    func testContainsAllPreviousItems() {
        for element in sut.songs {
            let containsElement = notRandomizedSongs.contains(where: {
                $0.artist == element.artist &&
                    $0.title == element.title
            })
            XCTAssertTrue(containsElement)
        }
    }
}
