import Foundation
@testable
import ShuffleSongs

final class ImageDataTaskStub: DataTask {
    
    private let result: Result<Data, Error>
    var hasCalledGetData: Bool = false
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    
    func getData(from url: URL, _ handler: @escaping (Result<Data, Error>) -> Void) {
        hasCalledGetData = true
        handler(result)
    }
}
