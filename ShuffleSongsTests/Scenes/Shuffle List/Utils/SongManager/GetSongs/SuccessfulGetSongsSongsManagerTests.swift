import XCTest
@testable
import ShuffleSongs

final class SuccessfulGetSongsSongsManagerTests: XCTestCase {
    
    private var sut: SongsManager!
    private var serviceStub: SongsServiceStub!
    
    override func setUp() {
        serviceStub = SongsServiceStub(result: .success(Song.jsonDummies()))
        sut = SongsManager(service: serviceStub)
        sut.getSongs(for: [], songsPerArtist: 10, onError: {})
    }
    
    override func tearDown() {
        serviceStub = nil
        sut = nil
    }
    
    func testHasCalledGetSongs() {
        XCTAssertTrue(serviceStub.hasCalledGetSongs)
    }
    
    func testHasSettedValuesForSongs() {
        XCTAssertFalse(sut.songs.isEmpty)
    }
}
