//
//  DayPhotosSheet.swift
//  Proovit

import SwiftUI

struct DayPhotosSheet: View {
    let date: Date
    let entries: [ProgressEntry]

    var body: some View {
        NavigationStack {
            ScrollView {
                if entries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No photos this day")
                            .foregroundColor(.secondary)
                    }
                    .padding(24)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 4)], spacing: 4) {
                        ForEach(entries) { entry in
                            // TODO: add tap to zoom
                            PhotoThumbnailView(filename: entry.photoFilename)
                                .frame(height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .padding(12)
                }
            }
            .navigationTitle(formatDate(date))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func formatDate(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: d)
    }
}
