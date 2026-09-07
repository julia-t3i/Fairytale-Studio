//
//  Models.swift
//  Fairytale Studio
//
//  Created by Julia Teixeira on 2026-07-17.
//

import SwiftUI
import SwiftData

// ─────────────────────────────────────────────────────────
// MARK: - PlacedAsset (Codable struct, stored inside BookPage)
// ─────────────────────────────────────────────────────────

struct PlacedAsset: Identifiable, Codable {
    var id: UUID = UUID()
    var imageName: String
    var displayName: String = ""
    var offset: CGSize
    var scale: CGFloat = 1.0
    var isSelected: Bool = false
    var rotation: Angle = .zero
    var isFlippedH: Bool = false
    var isFlippedV: Bool = false
    var importedImageData: Data? = nil
    var zIndex: Double = 0 

    // computed property so the rest of the code still uses asset.importedImage
    var importedImage: UIImage? {
        get {
            guard let data = importedImageData else { return nil }
            return UIImage(data: data)
        }
        set {
            importedImageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - PlacedText (SwiftData model)
// ─────────────────────────────────────────────────────────

struct PlacedText: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String = "The quick brown fox jumps over the lazy dog"
    var fontName: String = "Georgia"
    var fontSize: CGFloat = 24
    var isBold: Bool = false
    var isItalic: Bool = false
    var colorHex: String = "#4A2C0A"
    var offset: CGSize = .zero
    var rotation: Angle = .zero
    var scale: CGFloat = 1.0
    var isSelected: Bool = false
    var zIndex: Double = 0
    var textAlignment: String = "center"
    var width: CGFloat = 200
    var nsAttributedData: Data? = nil   // stores NSAttributedString via NSKeyedArchiver

    var nsAttributedString: NSAttributedString {
        get {
            guard let data = nsAttributedData,
                  let ns = try? NSKeyedUnarchiver.unarchivedObject(
                      ofClass: NSAttributedString.self, from: data
                  ) else {
                // fallback: plain text with base font
                let font = UIFont(name: fontName, size: fontSize)
                           ?? UIFont.systemFont(ofSize: fontSize)
                return NSAttributedString(
                    string: text,
                    attributes: [
                        .font: font,
                        .foregroundColor: UIColor(Color(hex: colorHex))
                    ]
                )
            }
            return ns
        }
        set {
            nsAttributedData = try? NSKeyedArchiver.archivedData(
                withRootObject: newValue,
                requiringSecureCoding: true
            )
            text = newValue.string
        }
    }

    // keep attributedString as a bridge for DraggableText's Text() view
    var attributedString: AttributedString {
        get {
            var result = AttributedString()
            let ns = nsAttributedString
            let fullRange = NSRange(location: 0, length: ns.length)
            ns.enumerateAttributes(in: fullRange) { attrs, nsRange, _ in
                guard let swiftRange = Range(nsRange, in: ns.string) else { return }
                let substring = String(ns.string[swiftRange])
                var chunk = AttributedString(substring)
                if let font = attrs[.font] as? UIFont {
                    chunk.font = Font(font)
                }
                if let color = attrs[.foregroundColor] as? UIColor {
                    chunk.foregroundColor = Color(color)
                }
                result.append(chunk)
            }
            return result
        }
        set {
            // convert back via NS for storage
            if let ns = try? NSAttributedString(newValue, including: \.uiKit) {
                nsAttributedString = ns
            }
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - BookPage (SwiftData model)
// ─────────────────────────────────────────────────────────

@Model
class BookPage {
    var placedAssets: [PlacedAsset] = []
    var placedTexts: [PlacedText] = []   
    var backgroundImageName: String? = nil
    var order: Int = 0

    init(order: Int = 0) {
        self.order = order
        self.placedAssets = []
        self.placedTexts = []
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Book (SwiftData model)
// ─────────────────────────────────────────────────────────

@Model
class Book {
    var title: String = "Untitled Story"
    var coverImageName: String = "book_cover"
    var coverImageData: Data? = nil 
    var createdAt: Date = Date()
    @Relationship(deleteRule: .cascade) var pages: [BookPage] = []

    init(title: String = "Untitled Story") {
        self.title = title
        self.createdAt = Date()
        let count = UserDefaults.standard.integer(forKey: "defaultPageCount")
        let pageCount = count > 0 ? count : 2
        self.pages = (0..<pageCount).map { BookPage(order: $0) }
    }

    // sorted pages helper
    var sortedPages: [BookPage] {
        pages.sorted { $0.order < $1.order }
    }
}
