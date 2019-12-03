import XCTest
@testable
import ShuffleSongs

final class InvalidDataImageDownloaderTests: XCTestCase {
    private var sut: ImageDownloader!
    private var onErrorWasCalled = false
    private var error: Error!
    
    override func setUp() {
        let imageData = "invalidData".data(using: .utf8)!
        let dataTask = ImageDataTaskStub(result: .success(imageData))
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
        let error = self.error as? ImageError
        XCTAssertNotNil(error)
        XCTAssertTrue(error == ImageError.invalidDataFormat)
    }
}
