import XCTest
@testable
import ShuffleSongs

final class FailingGetSongsSongsManagerTests: XCTestCase {
    
    private var sut: SongsManager!
    private var serviceStub: SongsServiceStub!
    private var hasCalledOnError = false
    
    override func setUp() {
        serviceStub = SongsServiceStub(result: .failure(URLError(.badServerResponse)))
        sut = SongsManager(service: serviceStub)
        sut.getSongs(for: [], songsPerArtist: 10, onError: onError)
    }
    
    private func onError() {
        hasCalledOnError = true
    }
    
    override func tearDown() {
        serviceStub = nil
        sut = nil
    }
    
    func testHasCalledGetData() {
        XCTAssertTrue(serviceStub.hasCalledGetSongs)
    }
    
    func testHasCalledOnError() {
        XCTAssertTrue(hasCalledOnError)
    }
}
