import SwiftData
import Foundation

@Model
class ProgressEntry {
    var id: UUID
    var photoFilename: String
    var capturedAt: Date
    var tracker: Tracker?

    init(photoFilename: String, capturedAt: Date = Date(), tracker: Tracker? = nil) {
        self.id = UUID()
        self.photoFilename = photoFilename
        self.capturedAt = capturedAt
        self.tracker = tracker
    }
}
