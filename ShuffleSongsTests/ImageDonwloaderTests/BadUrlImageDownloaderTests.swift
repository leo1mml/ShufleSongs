import XCTest
import SwiftUI
@testable
import ShuffleSongs

class BadUrlImageDownloaderTests: XCTestCase {
    private var sut: ImageDownloader!
    private var onErrorWasCalled = false
    private var error: Error!
    
    override func setUp() {
        let successImage = UIImage(named: "shuffle",
                                         in: Bundle(for: SuccessImageDownloadTests.self),
                                         compatibleWith: nil)!
        let imageData = successImage.pngData()!
        let dataTask = ImageDataTaskStub(result: .success(imageData))
        sut = ImageDownloader(defaultImageName: "shuffle", dataTask: dataTask)
        sut.getImageFrom(url: "", onError: onErrorHelper(error:))
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
        XCTAssertTrue(error == URLError(.badURL))
    }
}
