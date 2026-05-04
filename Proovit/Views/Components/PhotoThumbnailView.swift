import SwiftUI

struct PhotoThumbnailView: View {
    let filename: String
    @State var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                // TODO: add loading spinner maybe
                Color(.systemGray5)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    }
            }
        }
        .onAppear {
            guard let store = try? PhotoStore() else { return }
            image = store.image(for: filename)
        }
    }
}
