//
//  EditTrackerSheet.swift
//  Proovit

import SwiftUI
import SwiftData

struct EditTrackerSheet: View {
    var tracker: Tracker?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var name: String
    @State var selectedColor: String
    @State var selectedIcon: String
    @State var showDeleteConfirm = false

    init(tracker: Tracker? = nil) {
        self.tracker = tracker
        if let tracker {
            _name = State(initialValue: tracker.name)
            _selectedColor = State(initialValue: tracker.colorName)
            _selectedIcon = State(initialValue: tracker.iconName)
        } else {
            _name = State(initialValue: "")
            _selectedColor = State(initialValue: "Forest")
            _selectedIcon = State(initialValue: "figure.run")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Tracker name", text: $name)
                }

                Section("Color") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 8) {
                        ForEach(Theme.trackerPalette) { tc in
                            Circle()
                                .fill(tc.color)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    if tc.assetName == selectedColor {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.caption.bold())
                                    }
                                }
                                .onTapGesture { selectedColor = tc.assetName }
                        }
                    }
                }

                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 8) {
                        ForEach(Theme.trackerSymbols, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .font(.title3)
                                .frame(width: 36, height: 36)
                                .background(symbol == selectedIcon ? Color.green.opacity(0.2) : Color.clear)
                                .cornerRadius(6)
                                .onTapGesture { selectedIcon = symbol }
                        }
                    }
                }

                if tracker != nil {
                    Section {
                        Button("Delete Tracker", role: .destructive) {
                            showDeleteConfirm = true
                        }
                    }
                }
            }
            .navigationTitle(tracker != nil ? "Edit Tracker" : "New Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .confirmationDialog("Delete this tracker?", isPresented: $showDeleteConfirm) {
                Button("Delete", role: .destructive) { deleteTracker() }
            }
        }
    }

    func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if let tracker {
            tracker.name = trimmed
            tracker.colorName = selectedColor
            tracker.iconName = selectedIcon
        } else {
            let newTracker = Tracker(name: trimmed, colorName: selectedColor, iconName: selectedIcon)
            modelContext.insert(newTracker)
        }

        try? modelContext.save()
        dismiss()
    }

    func deleteTracker() {
        guard let tracker else { return }
        modelContext.delete(tracker)
        try? modelContext.save()
        dismiss()
    }
}
