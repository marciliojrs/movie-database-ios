import Foundation

enum FileReaderError: Error {
    case fileNotFound(String)
    case unknownError(NSError)
    case encodingData(Data)
}

class FileReader {
    static func readString(from file: String, extension: String) throws -> String {
        let data = try readData(from: file, extension: `extension`)
        if let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            throw FileReaderError.encodingData(data)
        }
    }

    static func readData(from file: String, extension: String) throws -> Data {
        if let path = Bundle(for: self).path(forResource: file, ofType: `extension`) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch let error as NSError {
                throw FileReaderError.unknownError(error)
            }
        } else {
            throw FileReaderError.fileNotFound("\(file).\(`extension`)")
        }
    }
}
