import Combine
import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

@MainActor
public final class ProfileStore: ObservableObject {
    @Published public private(set) var name: String
    @Published public private(set) var photoData: Data?

    private let defaults: UserDefaults
    private let nameKey = "profile.name"
    private let photoFileName = "profile_photo.jpg"
    private let defaultName = "Aldino Risqi Grasepta"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        name = defaults.string(forKey: nameKey) ?? defaultName
        photoData = Self.loadPhoto(fileName: photoFileName)
    }

    public var profileImage: Image {
        if let photoData, let image = Self.image(from: photoData) {
            return image
        }
        return Image("profile_photo", bundle: .main)
    }

    public func resolvedName(from input: String) -> String {
        let trimmedName = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? defaultName : trimmedName
    }

    public func save(name: String, photoData: Data?) {
        self.name = resolvedName(from: name)
        defaults.set(self.name, forKey: nameKey)

        if let photoData, let storedData = Self.compressedPhotoData(from: photoData) {
            self.photoData = storedData
            try? storedData.write(to: Self.photoURL(fileName: photoFileName), options: .atomic)
        }
    }

    private static func photoURL(fileName: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    private static func loadPhoto(fileName: String) -> Data? {
        try? Data(contentsOf: photoURL(fileName: fileName))
    }

    private static func image(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #else
        return nil
        #endif
    }

    private static func compressedPhotoData(from data: Data) -> Data? {
        #if canImport(UIKit)
        guard let image = UIImage(data: data) else { return data }
        return image.jpegData(compressionQuality: 0.8) ?? data
        #else
        return data
        #endif
    }
}
