import Combine
import SwiftUI
import Foundation

final class ImageDownloader: ObservableObject {
    
    @Published
    private(set) var storedImage: Image
    private let dataTask: DataTask
    
    init(defaultImageName: String, dataTask: DataTask) {
        storedImage = Image(defaultImageName)
        self.dataTask = dataTask
    }
    
    func getImageFrom(url: String,
                      onError: @escaping (Error) -> Void = {_ in }) {
        guard let url = URL(string: url) else {
            onError(URLError(.badURL))
            return
        }
        downloadImage(from: url, dataTask: dataTask, onError: onError)
    }
    
    private func downloadImage(from url: URL, dataTask: DataTask, onError: @escaping (Error) -> Void) {
        dataTask.getData(from: url) { result in
            switch result {
            case let .success(data):
                self.tryToSetImage(imageData: data, onError: onError)
            case let .failure(error):
                onError(error)
            }
        }
    }
    
    private func tryToSetImage(imageData: Data, onError: (Error) -> Void) {
        do {
            storedImage = try getImageFrom(data: imageData)
        } catch {
            onError(error)
        }
    }

    private func getImageFrom(data: Data) throws -> Image  {
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        throw ImageError.invalidDataFormat
    }
}
