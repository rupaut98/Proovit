import Foundation
import UIKit

class PhotoStore {

    let directory: URL

    init() throws {
        let appSupport = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        self.directory = appSupport.appendingPathComponent("Photos")
        try FileManager.default.createDirectory(at: self.directory, withIntermediateDirectories: true)
        print("photo store ready: \(self.directory.path)")
    }

    func save(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return "" // shouldn't happen but just in case
        }
        let filename = "\(UUID().uuidString).jpg"
        let fileURL = directory.appendingPathComponent(filename)
        try data.write(to: fileURL, options: .atomic)
        print("saved photo: \(filename)")
        return filename
    }

    func url(for filename: String) -> URL {
        directory.appendingPathComponent(filename)
    }

    func image(for filename: String) -> UIImage? {
        guard let data = try? Data(contentsOf: url(for: filename)) else { return nil }
        return UIImage(data: data)
    }

    func delete(_ filename: String) {
        try? FileManager.default.removeItem(at: url(for: filename))
    }
}
