import XCTest
@testable
import ShuffleSongs

final class FailingRequestImageDownloaderTests: XCTestCase {
    private var sut: ImageDownloader!
    private var onErrorWasCalled = false
    private var error: Error!
    
    override func setUp() {
        let error = URLError(.badServerResponse)
        let dataTask = ImageDataTaskStub(result: .failure(error))
        sut = ImageDownloader(defaultImageName: "shuffle", dataTask: dataTask)
        sut.getImageFrom(url: "validurl.com/image.png", onError: onErrorHelper(error:))
    }
    
    private func onErrorHelper(error: Error) {
        onErrorWasCalled = true
        self.error = error
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testOnErrorWasCalled() {
        XCTAssertTrue(onErrorWasCalled)
    }
    
    func testErrorIsUrlError() {
        let error = self.error as? URLError
        XCTAssertNotNil(error)
        XCTAssertTrue(error == URLError(.badServerResponse))
    }
}
