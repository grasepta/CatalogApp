import PhotosUI
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public struct EditProfileView: View {
    private enum Layout {
        static let photoSize: CGFloat = 140
        static let nameLimit = 40
    }

    @ObservedObject var profileStore: ProfileStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var isLoadingPhoto = false
    @State private var showDiscardConfirmation = false

    public init(profileStore: ProfileStore) {
        self.profileStore = profileStore
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                photoSection
                nameSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(pageBackground.ignoresSafeArea())
        .navigationTitle("Edit Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Batal", action: handleCancel)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Simpan", action: saveProfile)
                    .bold()
                    .disabled(!hasChanges || isLoadingPhoto)
            }
        }
        .interactiveDismissDisabled(hasChanges)
        .confirmationDialog(
            "Buang perubahan?",
            isPresented: $showDiscardConfirmation,
            titleVisibility: .visible
        ) {
            Button("Buang Perubahan", role: .destructive, action: dismiss.callAsFunction)
            Button("Lanjut Mengedit", role: .cancel) {}
        } message: {
            Text("Perubahan nama atau foto belum disimpan.")
        }
        .onAppear {
            name = profileStore.name
            photoData = profileStore.photoData
        }
        .onChange(of: selectedPhoto) { _, item in
            loadSelectedPhoto(item)
        }
    }

    private var photoSection: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                    profilePreview
                        .resizable()
                        .scaledToFill()
                        .frame(width: Layout.photoSize, height: Layout.photoSize)
                        .clipShape(Circle())

                    if isLoadingPhoto {
                        Circle()
                            .fill(.black.opacity(0.35))
                            .frame(width: Layout.photoSize, height: Layout.photoSize)
                        ProgressView()
                            .tint(.white)
                    }
                }
                .overlay {
                    Circle()
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "camera.fill")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.accentColor, in: Circle())
                        .overlay {
                            Circle()
                                .strokeBorder(.background, lineWidth: 3)
                        }
                        .offset(x: 2, y: 2)
                }
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Foto profil")
            .accessibilityHint("Ketuk untuk mengganti foto")

            VStack(spacing: 4) {
                Text(previewName)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Ganti Foto")
                        .font(.subheadline.weight(.semibold))
                        .frame(minWidth: 140)
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                .padding(.top, 8)
                .accessibilityLabel("Ganti foto profil")
                .accessibilityHint("Ketuk untuk mengganti foto")
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nama")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Image(systemName: "person")
                    .foregroundStyle(.secondary)
                TextField("Nama", text: $name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(fieldBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(.quaternary)
            }

            HStack {
                Text("Jika dikosongkan, nama kembali ke default.")
                Spacer()
                Text("\(name.count)/\(Layout.nameLimit)")
                    .monospacedDigit()
                    .foregroundStyle(name.count >= Layout.nameLimit ? Color.accentColor : .secondary)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .onChange(of: name) { _, newValue in
            if newValue.count > Layout.nameLimit {
                name = String(newValue.prefix(Layout.nameLimit))
            }
        }
    }

    private var previewName: String {
        profileStore.resolvedName(from: name)
    }

    private var hasChanges: Bool {
        let nameChanged = previewName != profileStore.name
        let photoChanged = photoData != nil && photoData != profileStore.photoData
        return nameChanged || photoChanged
    }

    private var profilePreview: Image {
        if let photoData, let image = image(from: photoData) {
            return image
        }
        return profileStore.profileImage
    }

    private var pageBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
        #else
        Color.gray.opacity(0.08)
        #endif
    }

    private var fieldBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemGroupedBackground)
        #else
        Color.white
        #endif
    }

    private func handleCancel() {
        if hasChanges {
            showDiscardConfirmation = true
        } else {
            dismiss()
        }
    }

    private func saveProfile() {
        profileStore.save(name: name, photoData: photoData)
        dismiss()
    }

    private func loadSelectedPhoto(_ item: PhotosPickerItem?) {
        guard let item else { return }
        isLoadingPhoto = true
        Task {
            photoData = try? await item.loadTransferable(type: Data.self)
            isLoadingPhoto = false
        }
    }

    private func image(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #else
        return nil
        #endif
    }
}
