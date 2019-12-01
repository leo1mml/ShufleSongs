import Foundation

protocol DataTask {
    func getData(from url: URL, _ handler: @escaping (Result<Data, Error>) -> Void)
}
