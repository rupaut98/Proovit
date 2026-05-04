//
//  CameraView.swift
//  Proovit

import SwiftUI
import SwiftData

struct CameraView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tracker.sortOrder) private var trackers: [Tracker]
    @State private var selectedTracker: Tracker?
    @State private var showPicker = false
    @State private var capturedImage: UIImage?
    @State var isSaving = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                if let capturedImage {
                    // photo preview
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)

                    // tracker picker
                    Picker("Tracker", selection: $selectedTracker) {
                        Text("Select tracker").tag(nil as Tracker?)
                        ForEach(trackers) { tracker in
                            Text(tracker.name).tag(tracker as Tracker?)
                        }
                    }
                    .pickerStyle(.menu)

                    HStack(spacing: 16) {
                        Button("Retake") {
                            self.capturedImage = nil
                        }
                        .buttonStyle(.bordered)

                        Button("Save") {
                            save()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .disabled(selectedTracker == nil || isSaving)
                    }
                } else {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)

                    Text("Take a progress photo")
                        .font(.title3)

                    Button("Open Camera") {
                        showPicker = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }

                Spacer()
            }
            .navigationTitle("Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(image: $capturedImage)
            }
            .onAppear {
                selectedTracker = trackers.first
            }
        }
    }

    private func save() {
        guard let image = capturedImage, let tracker = selectedTracker else { return }
        print("saving photo to \(tracker.name)")
        isSaving = true

        do {
            let store = try PhotoStore()
            let filename = try store.save(image)
            let entry = ProgressEntry(photoFilename: filename, capturedAt: Date(), tracker: tracker)
            modelContext.insert(entry)
            try modelContext.save()
            dismiss()
        } catch {
            print("error saving: \(error)")
            isSaving = false
        }
    }
}

// from hackingwithswift.com - UIImagePickerController wrapper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // not needed but required by protocol
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
