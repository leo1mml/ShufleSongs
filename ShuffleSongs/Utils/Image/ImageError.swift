import Foundation

enum ImageError: String, Error, CustomStringConvertible {
    
    case invalidDataFormat = "Could not decode an image from the given data object."
    
    var description: String {
        return self.rawValue
    }
}
