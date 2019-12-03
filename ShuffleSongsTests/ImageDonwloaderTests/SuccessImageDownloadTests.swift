import XCTest
import SwiftUI
@testable
import ShuffleSongs

class SuccessImageDownloadTests: XCTestCase {
    
    private var sut: ImageDownloader!
    private var dataTask: ImageDataTaskStub!

    override func setUp() {
        let successImage = UIImage(named: "shuffle",
                                         in: Bundle(for: SuccessImageDownloadTests.self),
                                         compatibleWith: nil)!
        let imageData = successImage.pngData()!
        dataTask = ImageDataTaskStub(result: .success(imageData))
        sut = ImageDownloader(defaultImageName: "shuffle", dataTask: dataTask)
        sut.getImageFrom(url: "anyvalidurl.com/image.png")
    }

    override func tearDown() {
        sut = nil
        dataTask = nil
    }

    func testGetDataWasCalled() {
        XCTAssertTrue(dataTask.hasCalledGetData)
    }
    
    func testStoredImageWasSetted() {
        XCTAssertNotNil(sut.storedImage)
    }

}
