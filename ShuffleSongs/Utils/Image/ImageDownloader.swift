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
        if let image = ImageCache.shared.object(forKey: NSString(string: url)) {
            storedImage = Image(uiImage: image)
            return
        }
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
                self.tryToSetImage(imageData: data, imageUrl: url.absoluteString as NSString, onError: onError)
            case let .failure(error):
                onError(error)
            }
        }
    }
    
    private func tryToSetImage(imageData: Data, imageUrl: NSString, onError: (Error) -> Void) {
        do {
            storedImage = try getImageFrom(data: imageData, caching: imageUrl)
        } catch {
            onError(error)
        }
    }

    private func getImageFrom(data: Data, caching key: NSString) throws -> Image  {
        if let uiImage = UIImage(data: data) {
            ImageCache.shared.setObject(uiImage, forKey: key)
            return Image(uiImage: uiImage)
        }
        throw ImageError.invalidDataFormat
    }
}
