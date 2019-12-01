import Foundation

protocol DataTask {
    func getData(from url: URL, _ handler: (Result<Data, Error>) -> Void)
}
