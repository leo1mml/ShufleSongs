import Foundation

final class ImageDataTask: DataTask {
    func getData(from url: URL, _ handler: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let data = data {
                handler(.success(data))
                return
            }
        }.resume()
    }
}
