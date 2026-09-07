//
//  ContentView.swift
//  Fairytale Studio
//
//  Created by Julia Teixeira on 2026-06-08.
//

import SwiftUI
import SwiftData
import PhotosUI

// ─────────────────────────────────────────────────────────
// MARK: - Asset Library 
// ─────────────────────────────────────────────────────────

enum AssetCategory: String, CaseIterable {
    case characters = "Characters"
    case backgrounds = "Backgrounds"
    case props = "Props"
    case speechBubbles = "Bubbles"
    case text = "Text"
}

struct AssetSubcategory: Identifiable {
    let id: String
    let name: String
    let category: AssetCategory
    var description : String = ""
    var assets: [AssetItem]
}

struct AssetItem: Identifiable {
    let id: String
    let name: String
    let displayName: String
    var description: String = ""
}

struct AssetLibrary {
    static let subcategories: [AssetSubcategory] = [
        AssetSubcategory(id: "bunny", name: "Bunny", category: .characters, description: "Carrots only beyond this point.", assets: [
            AssetItem(id: "char_bunny_sit",   name: "char_bunny_sit",   displayName: "Sitting", description: "Rest your legs."),
            AssetItem(id: "char_bunny_stand", name: "char_bunny_stand", displayName: "Standing", description: "Ready for action."),
            AssetItem(id: "char_bunny_wait",  name: "char_bunny_wait",  displayName: "Waiting", description: "Patience is key."),
        ]),
        AssetSubcategory(id: "fox", name: "Fox", category: .characters, description: "What does the fox say?", assets: [
            AssetItem(id: "char_fox_sit",   name: "char_fox_sit",   displayName: "Sitting", description: "Relaxing."),
            AssetItem(id: "char_fox_stand", name: "char_fox_stand", displayName: "Standing", description: "Up and at 'em."),
        ]),
        AssetSubcategory(id: "squirrel", name: "Squirrel", category: .characters, description: "Number one dog ragebaiter.", assets: [
            AssetItem(id: "char_squirrel_sit", name: "char_squirrel_sit", displayName: "Sitting", description: "I'll only rest for TWO minutes, hear me?"),
            AssetItem(id: "char_squirrel_run", name: "char_squirrel_run", displayName: "Running", description: "RUN! A DOG!"),
        ]),
        AssetSubcategory(id: "bg_forest", name: "Forest", category: .backgrounds, description: "Luscious and leafy.", assets: [
            AssetItem(id: "bg_forest",   name: "bg_forest",   displayName: "Forest", description: "What if we put a data center RIGHT here?"),
        ]),
        AssetSubcategory(id: "bg_kitchen", name: "Kitchen", category: .backgrounds, description: "Smells delicious.", assets: [
            AssetItem(id: "bg_kitchen_empty", name: "bg_kitchen_empty", displayName: "Empty Kitchen", description: "Decorate to your heart's content."),
            AssetItem(id: "bg_kitchen_full", name: "bg_kitchen_full", displayName: "Decorated Kitchen", description: "For the gourmet."),
        ]),
        AssetSubcategory(id: "kitchen_props", name: "Kitchen Props", category: .props, description: "What can I cook with?", assets: [
            AssetItem(id: "cabnet", name: "cabnet", displayName: "Cabnet"),
            AssetItem(id: "blender", name: "blender", displayName: "Blender"),
            AssetItem(id: "shelves", name: "shelves", displayName: "Shelves"),
            AssetItem(id: "bulletin", name: "bulletin", displayName: "Bulletin Board"),
            AssetItem(id: "dishes", name: "dishes", displayName: "Dishes"),
            AssetItem(id: "sink", name: "sink", displayName: "Sink"),
            AssetItem(id: "drawer", name: "drawer", displayName: "Drawer"),
            AssetItem(id: "vase", name: "vase", displayName: "Vase"),
            AssetItem(id: "pans", name: "pans", displayName: "Pans"),
            AssetItem(id: "stove", name: "stove", displayName: "Stove"),
            AssetItem(id: "pots", name: "pots", displayName: "Pots"),
            AssetItem(id: "fridge", name: "fridge", displayName: "Fridge"),
            AssetItem(id: "broom", name: "broom", displayName: "Broom"),
            AssetItem(id: "table", name: "table", displayName: "Dinner Table"),
        ]),
    ]
}

struct FontOption: Identifiable {
    let id = UUID()
    let displayName: String
    let fontName: String
    let sampleText: String
}

let availableFonts: [FontOption] = [
    FontOption(displayName: "Classic Serif",    fontName: "Georgia",              sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Elegant",          fontName: "Didot",                sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Playful",          fontName: "MarkerFelt-Wide",      sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Storybook",        fontName: "Baskerville-Bold",     sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Friendly",         fontName: "Chalkboard SE",        sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Modern",           fontName: "Futura-Medium",        sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Handwritten",      fontName: "Bradley Hand",         sampleText: "The quick brown fox jumps over the lazy dog"),
    FontOption(displayName: "Whimsical",        fontName: "Papyrus",              sampleText: "The quick brown fox jumps over the lazy dog"),
]

// ─────────────────────────────────────────────────────────
// MARK: - App Entry
// ─────────────────────────────────────────────────────────

struct ContentView: View {
    @State private var showLibrary = false

    var body: some View {
        ZStack {
            if showLibrary {
                LibraryView()
            } else {
                IntroView(onStart: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeInOut(duration: 0.9)) {
                            showLibrary = true
                        }
                    }
                })
            }
        }
        .onAppear {
            AudioManager.shared.startMusic()
            // listen for main menu request from LibraryView
            NotificationCenter.default.addObserver(
                forName: Notification.Name("GoToMainMenu"),
                object: nil,
                queue: .main
            ) { _ in
                withAnimation(.easeInOut(duration: 0.6)) {
                    showLibrary = false
                }
            }
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Library
// ─────────────────────────────────────────────────────────

struct LibraryView: View {
    @Query(sort: \Book.createdAt) private var books: [Book]
    @Environment(\.modelContext) private var modelContext
    @State private var bookToRename: Book? = nil
    @State private var showingRenameAlert = false
    @State private var renamedTitle = ""
    @State private var bookToEdit: Book? = nil
    @State private var showingEditMenu = false
    @State private var showingCoverPicker = false
    @State private var showingExportSheet = false
    @State private var coverPickerItem: PhotosPickerItem? = nil
    @State private var exportImages: [UIImage] = []

    var body: some View {
        NavigationStack {
            ZStack {
                // ── Your background illustration ──────────────
                Image("MyStories_screen")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // ── Book grid ─────────────────────────────────
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 24) {
                        ForEach(books) { book in
                            NavigationLink {
                                BookEditorView(book: book)
                            } label: {
                                BookCoverThumbnail(
                                    book: book,
                                    onRename: {
                                        bookToRename = book
                                        renamedTitle = book.title
                                        showingRenameAlert = true
                                    },
                                    onEditCover: {
                                        bookToEdit = book
                                        showingCoverPicker = true
                                    },
                                    onExport: {
                                        bookToEdit = book
                                        showingExportSheet = true
                                    },
                                    onDelete: {
                                        modelContext.delete(book)
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        Button {
                            let newBook = Book()
                            modelContext.insert(newBook)
                        } label: {
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.brown.opacity(0.06))
                                    .aspectRatio(3/4, contentMode: .fit)
                                    .overlay(
                                        VStack(spacing: 10) {
                                            Image(systemName: "plus")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color.brown.opacity(0.4))
                                            Text("New Story")
                                                .font(.subheadline)
                                                .foregroundStyle(Color.brown.opacity(0.5))
                                        }
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                style: StrokeStyle(lineWidth: 1.5, dash: [5])
                                            )
                                            .foregroundStyle(Color.brown.opacity(0.2))
                                    )
                                Text("New Story")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.brown.opacity(0.8))
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 260)   // push grid down so it clears the My Stories label
                    .padding(.horizontal, 125)
                    .padding(.bottom, 100) // space for main menu button at bottom
                }

                // ── Main Menu button — bottom centre ──────────
                VStack {
                    Spacer()
                    Button {
                        // navigate back to intro — need to pass this closure up
                        // for now wire via NotificationCenter
                        NotificationCenter.default.post(
                            name: Notification.Name("GoToMainMenu"), object: nil
                        )
                    } label: {
                        Image("mainmenu_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 260)
                            .contentShape(RoundedRectangle(cornerRadius: 16)
                                .size(width: 220, height: 65))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 80)
                }
            }
            .navigationBarHidden(true)
            // ── Cover photo picker ────────────────────────────
            .photosPicker(
                isPresented: $showingCoverPicker,
                selection: $coverPickerItem,
                matching: .images
            )
            .onChange(of: coverPickerItem) { _, newItem in
                Task {
                    if let newItem,
                       let data = try? await newItem.loadTransferable(type: Data.self),
                       let book = bookToEdit {
                        book.coverImageData = data
                        coverPickerItem = nil
                    }
                }
            }

            // ── Export sheet ──────────────────────────────────
            .sheet(isPresented: $showingExportSheet) {
                if let book = bookToEdit {
                    ExportSheetView(book: book)
                }
            }
            .alert("Rename Story", isPresented: $showingRenameAlert) {
                TextField("Story title", text: $renamedTitle)
                Button("Save") {
                    if let target = bookToRename,
                       !renamedTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                        target.title = renamedTitle
                    }
                    bookToRename = nil
                    renamedTitle = ""
                }
                Button("Cancel", role: .cancel) {
                    bookToRename = nil
                    renamedTitle = ""
                }
            } message: {
                Text("Enter a new title for this story")
            }
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Export Sheet
// ─────────────────────────────────────────────────────────

struct ExportSheetView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @State private var isExporting = false
    @State private var exportedImages: [UIImage] = []
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // ── Cover ratio hint ───────────────────────
                VStack(spacing: 8) {
                    Text("Export \(book.title)")
                        .font(.title2.bold())
                    Text("Recommended cover ratio: 3:4 (portrait)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                // ── Cover preview ──────────────────────────
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.brown.opacity(0.1))
                        .aspectRatio(3/4, contentMode: .fit)
                        .frame(width: 160)

                    if let data = book.coverImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "book.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.brown.opacity(0.3))
                            Text(book.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .shadow(radius: 6)

                Text("\(book.pages.count) pages")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Divider()

                // ── Export options ─────────────────────────
                VStack(spacing: 12) {
                    Text("Export as")
                        .font(.headline)

                    HStack(spacing: 16) {
                        ExportOptionButton(
                            icon: "photo.stack",
                            label: "PNG",
                            subtitle: "One image per page"
                        ) {
                            exportAsImages()
                        }

                        ExportOptionButton(
                            icon: "doc.richtext",
                            label: "PDF",
                            subtitle: "All pages in one file"
                        ) {
                            exportAsPDF()
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: shareItems)
            }
        }
    }

    func exportAsImages() {
        var items: [Any] = []

        // cover
        if let data = book.coverImageData, let img = UIImage(data: data) {
            items.append(img)
        }

        // each page rendered as a screenshot placeholder
        // (full render requires UIKit snapshot — this gives page background images)
        for page in book.pages.sorted(by: { $0.order < $1.order }) {
            if let bgName = page.backgroundImageName,
               let img = UIImage(named: bgName) {
                items.append(img)
            }
        }

        if items.isEmpty {
            items.append("No images to export — add backgrounds to your pages first.")
        }

        shareItems = items
        showingShareSheet = true
    }

    func exportAsPDF() {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        let data = pdfRenderer.pdfData { context in
            // cover page
            context.beginPage()
            if let coverData = book.coverImageData,
               let img = UIImage(data: coverData) {
                img.draw(in: CGRect(x: 0, y: 0, width: 595, height: 842))
            } else {
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 36),
                    .foregroundColor: UIColor.brown
                ]
                (book.title as NSString).draw(at: CGPoint(x: 40, y: 380), withAttributes: attrs)
            }

            // pages
            for page in book.pages.sorted(by: { $0.order < $1.order }) {
                context.beginPage()
                if let bgName = page.backgroundImageName,
                   let img = UIImage(named: bgName) {
                    img.draw(in: CGRect(x: 0, y: 0, width: 595, height: 842))
                }
            }
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(book.title).pdf")
        try? data.write(to: tempURL)
        shareItems = [tempURL]
        showingShareSheet = true
    }
}

struct ExportOptionButton: View {
    let icon: String
    let label: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundStyle(Color.brown.opacity(0.7))

                VStack(spacing: 2) {
                    Text(label)
                        .font(.body.bold())
                        .foregroundStyle(Color.brown.opacity(0.9))

                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(Color.brown.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.brown.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.brown.opacity(0.15), lineWidth: 1)
            )
        }
    }
}

// UIKit share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// ─────────────────────────────────────────────────────────
// MARK: - Book Cover Thumbnail
// ─────────────────────────────────────────────────────────

struct BookCoverThumbnail: View {
    let book: Book
    let onRename: () -> Void
    let onEditCover: () -> Void
    let onExport: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteConfirm = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {

                // ── Cover background ──────────────────────
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Group {
                            if let data = book.coverImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else if UIImage(named: book.coverImageName) != nil {
                                Image(book.coverImageName)
                                    .resizable()
                                    .scaledToFill()
                            }
                            // no else — leave plain brown background
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // ── Title — centred and big ───────────────
                Text(book.title)
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .brown.opacity(0.6), radius: 4, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // centres it in the card

                // ── Edit menu button ──────────────────────
                Menu {
                    Button { onRename() } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    Button { onEditCover() } label: {
                        Label("Change Cover", systemImage: "photo")
                    }
                    Button { onExport() } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive) {
                        showingDeleteConfirm = true
                    } label: {
                        Label("Delete Story", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                        .shadow(radius: 3)
                        .padding(10)
                }
            }
            .shadow(radius: 4)

            // ── Name below card ───────────────────────────
            Text(book.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.brown.opacity(0.8))
                .lineLimit(1)
            
            .confirmationDialog(
                "Delete \"\(book.title)\"?",
                isPresented: $showingDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    onDelete()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone. All pages and assets in this story will be permanently deleted.")
            }
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Book Editor
// ─────────────────────────────────────────────────────────

struct BookEditorView: View {
    var book: Book  // class reference, no @Binding needed
    @Environment(\.modelContext) private var modelContext
    @State private var currentPageIndex = 0
    @State private var isShowingCover = true

    // panel state
    @State private var openCategory: AssetCategory? = nil
    @State private var openSubcategory: AssetSubcategory? = nil
    @State private var customSubcategories: [AssetSubcategory] = []
    @State private var importedImages: [String: UIImage] = [:]
    @State private var showingLayerPanel = false
    @State private var showingFontPicker = false
    @State private var selectedTextID: UUID? = nil

    // sorted pages so order is always correct
    var sortedPages: [BookPage] {
        book.pages.sorted { $0.order < $1.order }
    }

    var body: some View {
        VStack(spacing: 0) {
            if isShowingCover {
                // ── Cover screen ──────────────────────────
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        BookCoverView(book: book) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingCover = false
                            }
                        }
                        .frame(
                            width: geo.size.width * 0.55,
                            height: geo.size.height * 0.85
                        )
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 16)

            } else {
                // ── Category bar ──────────────────────────
                CategoryBar(
                    openCategory: $openCategory,
                    openSubcategory: $openSubcategory,
                    onTextTapped: {
                        openCategory = nil
                        openSubcategory = nil
                        withAnimation(.spring(duration: 0.3)) {
                            showingFontPicker = true
                        }
                    }
                )

                // ── Book pages + panel ────────────────────
                GeometryReader { geo in
                    if currentPageIndex < sortedPages.count {
                        let page = sortedPages[currentPageIndex]
                        BookPagesView(
                            placedAssets: Binding(
                                get: { page.placedAssets },
                                set: { page.placedAssets = $0 }
                            ),
                            placedTexts: Binding(
                                get: { page.placedTexts },
                                set: { page.placedTexts = $0 }
                            ),
                            backgroundImageName: page.backgroundImageName,
                            onAssetSelected: {
                                withAnimation(.spring(duration: 0.3)) {
                                    selectedTextID = nil
                                }
                            },
                            onTextSelected: { id in
                                selectedTextID = id
                                withAnimation(.spring(duration: 0.3)) {
                                    showingFontPicker = false
                                }
                            },
                            onTextDeleted: {
                                selectedTextID = nil
                            }
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.3)) {
                                openCategory = nil
                                openSubcategory = nil
                                showingLayerPanel = false
                                showingFontPicker = false
                                selectedTextID = nil
                                for i in page.placedTexts.indices {
                                    page.placedTexts[i].isSelected = false
                                }
                                for i in page.placedAssets.indices {
                                    page.placedAssets[i].isSelected = false
                                }
                            }
                        }
                        .overlay {
                            if openCategory != nil {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring(duration: 0.3)) {
                                            openCategory = nil
                                            openSubcategory = nil
                                        }
                                    }
                                    .ignoresSafeArea()
                            }
                        }
                        .overlay(alignment: .trailing) {
                            if let category = openCategory {
                                PresetPanelView(
                                    category: category,
                                    openSubcategory: $openSubcategory,
                                    customSubcategories: $customSubcategories,
                                    importedImages: importedImages,
                                    onAssetTapped: { asset in
                                        if openCategory == .backgrounds {
                                            page.backgroundImageName = asset.name
                                        } else {
                                            var newAsset = PlacedAsset(imageName: asset.name, offset: .zero)
                                            newAsset.importedImage = importedImages[asset.name]
                                            newAsset.displayName = asset.displayName
                                            newAsset.zIndex = Double(page.placedAssets.count)
                                            page.placedAssets.append(newAsset)
                                        }
                                    },
                                    onImageImported: { image, subcategoryID, name in
                                        let imageID = UUID().uuidString
                                        importedImages[imageID] = image
                                        if let index = customSubcategories.firstIndex(where: { $0.id == subcategoryID }) {
                                            customSubcategories[index].assets.append(
                                                AssetItem(id: imageID, name: imageID, displayName: name)
                                            )
                                        }
                                    },
                                    onDeleteSubcategory: { id in
                                        withAnimation {
                                            customSubcategories.removeAll { $0.id == id }
                                        }
                                        if openSubcategory?.id == id { openSubcategory = nil }
                                    },
                                    onRenameSubcategory: { id, newName in
                                        if let index = customSubcategories.firstIndex(where: { $0.id == id }) {
                                            customSubcategories[index] = AssetSubcategory(
                                                id: customSubcategories[index].id,
                                                name: newName,
                                                category: customSubcategories[index].category,
                                                assets: customSubcategories[index].assets
                                            )
                                        }
                                    },
                                    onDeleteAsset: { subcategoryID, assetID in
                                        if let index = customSubcategories.firstIndex(where: { $0.id == subcategoryID }) {
                                            customSubcategories[index].assets.removeAll { $0.id == assetID }
                                            importedImages.removeValue(forKey: assetID)
                                        }
                                    },
                                    onRenameAsset: { assetID, newName in
                                        for i in customSubcategories.indices {
                                            if let j = customSubcategories[i].assets.firstIndex(where: { $0.id == assetID }) {
                                                customSubcategories[i].assets[j] = AssetItem(
                                                    id: assetID,
                                                    name: assetID,
                                                    displayName: newName
                                                )
                                            }
                                        }
                                    }
                                )
                                .frame(width: 320)
                                .padding(.top, 12)
                                .padding(.trailing, 35)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .overlay {
                            if showingLayerPanel {
                                // invisible tap catcher behind the panel
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring(duration: 0.3)) {
                                            showingLayerPanel = false
                                        }
                                    }
                                    .ignoresSafeArea()
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if showingLayerPanel {
                                LayerPanelView(
                                    placedAssets: Binding(
                                        get: { page.placedAssets },
                                        set: { page.placedAssets = $0 }
                                    ),
                                    placedTexts: Binding(
                                        get: { page.placedTexts },
                                        set: { page.placedTexts = $0 }
                                    )
                                )
                                .frame(width: 260)
                                .padding(.top, 8)
                                .padding(.trailing, 35)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        
                        // ── Dismiss font picker on tap outside ───────────
                        .overlay {
                            if showingFontPicker {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring(duration: 0.3)) {
                                            showingFontPicker = false
                                        }
                                    }
                                    .ignoresSafeArea()
                            }
                        }
                        // ── Font picker (slides up from bottom) ──────────
                        .overlay(alignment: .bottom) {
                            if showingFontPicker {
                                FontPickerPanel { fontOption in
                                    let newText = PlacedText(
                                        text: "The quick brown fox jumped over the lazy dog.",
                                        fontName: fontOption.fontName,
                                        zIndex: Double(page.placedAssets.count + page.placedTexts.count)
                                    )
                                    page.placedTexts.append(newText)
                                    selectedTextID = newText.id
                                    withAnimation(.spring(duration: 0.3)) {
                                        showingFontPicker = false
                                    }
                                }
                                .frame(maxWidth: 480)
                                .frame(height: 400)
                                .padding(.bottom, 20)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }

                        // ── Text edit panel (bottom, when text selected) ──
                        .overlay(alignment: .bottom) {
                            if let selectedID = selectedTextID {
                                let matchIndex = page.placedTexts.firstIndex(where: {
                                    $0.id == selectedID && $0.isSelected
                                })
                                if let textIndex = matchIndex {
                                    TextEditPanel(
                                        placedText: Binding(
                                            get: {
                                                guard textIndex < page.placedTexts.count else {
                                                    return PlacedText()
                                                }
                                                return page.placedTexts[textIndex]
                                            },
                                            set: { newVal in
                                                guard textIndex < page.placedTexts.count else { return }
                                                page.placedTexts[textIndex] = newVal
                                            }
                                        )
                                    )
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                    .contentShape(Rectangle())
                                    .onTapGesture { }
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 16)
            }
        }
        .onDisappear {
            for page in book.pages {
                for i in page.placedAssets.indices {
                    page.placedAssets[i].isSelected = false
                }
            }
        }
        .background(
            Image("wood_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(!isShowingCover)
        .toolbar {
            if !isShowingCover {
                // exit button — dark brown
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        for page in book.pages {
                            for i in page.placedAssets.indices {
                                page.placedAssets[i].isSelected = false
                            }
                        }
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isShowingCover = true
                            openCategory = nil
                            openSubcategory = nil
                            showingLayerPanel = false
                        }
                    } label: {
                        Image(systemName: "book.closed")
                            .foregroundStyle(Color(red: 0.35, green: 0.18, blue: 0.05))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.85, green: 0.72, blue: 0.55))
                            )
                    }
                }

                // layer button — dark brown
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            showingLayerPanel.toggle()
                        }
                    } label: {
                        Image(systemName: "square.3.layers.3d")
                            .foregroundStyle(Color(red: 0.35, green: 0.18, blue: 0.05))
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.85, green: 0.72, blue: 0.55))
                            )
                    }
                }

                // page controls — dark brown text, styled background
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 16) {
                        Button {
                            guard currentPageIndex > 0 else { return }
                            if currentPageIndex < sortedPages.count {
                                for i in sortedPages[currentPageIndex].placedAssets.indices {
                                    sortedPages[currentPageIndex].placedAssets[i].isSelected = false
                                }
                            }
                            withAnimation(.easeInOut(duration: 0.35)) { currentPageIndex -= 1 }
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(
                                    currentPageIndex > 0
                                    ? Color(red: 0.05, green: 0.05, blue: 0.05)
                                    : Color(red: 0.05, green: 0.05, blue: 0.05).opacity(0.4)
                                )
                        }

                        Text("Page \(currentPageIndex + 1) of \(book.pages.count)")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color(red: 0.35, green: 0.18, blue: 0.05))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.85, green: 0.72, blue: 0.55).opacity(0.85))
                            )

                        Button {
                            if currentPageIndex < sortedPages.count {
                                for i in sortedPages[currentPageIndex].placedAssets.indices {
                                    sortedPages[currentPageIndex].placedAssets[i].isSelected = false
                                }
                            }
                            if currentPageIndex == book.pages.count - 1 {
                                let newPage = BookPage(order: book.pages.count)
                                modelContext.insert(newPage)
                                book.pages.append(newPage)
                            }
                            withAnimation(.easeInOut(duration: 0.35)) { currentPageIndex += 1 }
                        } label: {
                            Image(systemName: currentPageIndex == book.pages.count - 1
                                  ? "plus.circle"
                                  : "chevron.right")
                                .foregroundStyle(Color(red: 0.05, green: 0.05, blue: 0.05))
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Book Cover Screen
// ─────────────────────────────────────────────────────────

struct BookCoverView: View {
    let book: Book
    let onOpen: () -> Void

    var body: some View {
        ZStack {
            // ── Background: imported photo first, then named, then fallback ──
            if let data = book.coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if UIImage(named: book.coverImageName) != nil {
                Image(book.coverImageName)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.brown.opacity(0.25))
            }

            // ── Title always on top ────────────────────────────────────────
            VStack {
                Spacer()
                Text(book.title)
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .brown.opacity(0.5), radius: 6, x: 0, y: 3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer()
                Text("Tap to open")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .brown.opacity(0.4), radius: 2)
                    .padding(.bottom, 32)
            }
        }
        .aspectRatio(0.7, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 12)
        .onTapGesture { onOpen() }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Book Pages
// ─────────────────────────────────────────────────────────

struct BookPagesView: View {
    @Binding var placedAssets: [PlacedAsset]
    @Binding var placedTexts: [PlacedText]
    var backgroundImageName: String? = nil
    let onAssetSelected: () -> Void
    let onTextSelected: (UUID) -> Void
    let onTextDeleted: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ── Open book base ─────────────────────────
                Image("open_book")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 1.25, height: geo.size.height * 1.25)
                    .padding(.bottom, 45)

                // ── Content masked to book shape ───────────
                ZStack {
                    // background fills the whole book area
                    if let bgName = backgroundImageName {
                        Image(bgName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }

                    // tap to deselect
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            for i in placedAssets.indices { placedAssets[i].isSelected = false }
                            for i in placedTexts.indices { placedTexts[i].isSelected = false }
                        }

                    // assets
                    ForEach($placedAssets) { $asset in
                        DraggableAsset(
                            asset: $asset,
                            onDelete: { placedAssets.removeAll { $0.id == asset.id } },
                            onSelect: {
                                for i in placedAssets.indices {
                                    if placedAssets[i].id != asset.id {
                                        placedAssets[i].isSelected = false
                                    }
                                }
                                for i in placedTexts.indices {
                                    placedTexts[i].isSelected = false
                                }
                                onAssetSelected()
                            }
                        )
                        .zIndex(asset.zIndex)
                    }

                    // texts
                    ForEach($placedTexts) { $text in
                        DraggableText(
                            placedText: $text,
                            onDelete: {
                                placedTexts[placedTexts.firstIndex(where: { $0.id == text.id })!].isSelected = false
                                DispatchQueue.main.async {
                                    placedTexts.removeAll { $0.id == text.id }
                                    onTextDeleted()
                                }
                            },
                            onSelect: {
                                for i in placedAssets.indices { placedAssets[i].isSelected = false }
                                for i in placedTexts.indices {
                                    if placedTexts[i].id != text.id {
                                        placedTexts[i].isSelected = false
                                    }
                                }
                                onTextSelected(text.id)
                            }
                        )
                        .zIndex(text.zIndex)
                    }
                }
                // mask content to the exact shape of the open book PNG
                .mask {
                    Image("open_book")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 1.22, height: geo.size.height * 1.225)
                        .padding(.bottom, 45)
                }

                // ── Spine on top of everything ─────────────
                Image("book_spine")
                    .resizable()
                    .scaledToFit()
                    .frame(height: geo.size.height * 1.25)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 45)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            // no .clipped() here so selection handles can show outside book
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Layer Panel
// ─────────────────────────────────────────────────────────

struct LayerPanelView: View {
    @Binding var placedAssets: [PlacedAsset]
    @Binding var placedTexts: [PlacedText]
    
    enum AnyLayer: Identifiable {
        case asset(PlacedAsset)
        case text(PlacedText)

        var id: UUID {
            switch self {
            case .asset(let a): return a.id
            case .text(let t): return t.id
            }
        }
        var zIndex: Double {
            switch self {
            case .asset(let a): return a.zIndex
            case .text(let t): return t.zIndex
            }
        }
        var isSelected: Bool {
            switch self {
            case .asset(let a): return a.isSelected
            case .text(let t): return t.isSelected
            }
        }
        var displayName: String {
            switch self {
            case .asset(let a): return a.displayName.isEmpty ? "Asset" : a.displayName
            case .text(let t):
                let preview = String(t.text.prefix(20))
                return preview.isEmpty ? "Text" : preview
            }
        }
    }

    var allLayers: [AnyLayer] {
        let assetLayers = placedAssets.map { AnyLayer.asset($0) }
        let textLayers = placedTexts.map { AnyLayer.text($0) }
        return (assetLayers + textLayers).sorted { $0.zIndex > $1.zIndex }
    }

    // layers ordered top to bottom (highest zIndex first)
    var orderedAssets: [PlacedAsset] {
        placedAssets.sorted { $0.zIndex > $1.zIndex }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Layers")
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(allLayers) { layer in
                        let isSelected = layer.isSelected
                        HStack(spacing: 14) {
                            // thumbnail or text preview
                            Group {
                                switch layer {
                                case .asset(let a):
                                    if let uiImage = a.importedImage {
                                        Image(uiImage: uiImage).resizable().scaledToFit()
                                    } else {
                                        Image(a.imageName).resizable().scaledToFit()
                                    }
                                case .text(let t):
                                    Text(String(t.text.prefix(4)))
                                        .font(.custom(t.fontName, size: 16))
                                        .foregroundStyle(Color(hex: t.colorHex))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.brown.opacity(0.08)))

                            // layer icon to distinguish type
                            Image(systemName: layer.id == (allLayers.first?.id ?? UUID())
                                  ? "character.cursor.ibeam"
                                  : "photo")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.secondary)

                            Text(layer.displayName)
                                .font(.subheadline)
                                .foregroundStyle(isSelected ? Color.blue : Color.primary)
                                .lineLimit(1)

                            Spacer()

                            VStack(spacing: 8) {
                                Button { moveLayer(id: layer.id, direction: .toFront) } label: {
                                    Image(systemName: "square.3.layers.3d.top.filled")
                                        .font(.system(size: 16)).foregroundStyle(Color.secondary)
                                }
                                Button { moveLayer(id: layer.id, direction: .forward) } label: {
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 16)).foregroundStyle(Color.secondary)
                                }
                                Button { moveLayer(id: layer.id, direction: .backward) } label: {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 16)).foregroundStyle(Color.secondary)
                                }
                                Button { moveLayer(id: layer.id, direction: .toBack) } label: {
                                    Image(systemName: "square.3.layers.3d.bottom.filled")
                                        .font(.system(size: 16)).foregroundStyle(Color.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(isSelected ? Color.blue.opacity(0.08) : Color.clear)

                        Divider()
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
    }

    enum MoveDirection { case forward, backward, toFront, toBack }

    func moveLayer(id: UUID, direction: MoveDirection) {
        let allCount = placedAssets.count + placedTexts.count
        let maxZ = Double(allCount - 1)

        withAnimation(.easeInOut(duration: 0.2)) {
            if let i = placedAssets.firstIndex(where: { $0.id == id }) {
                switch direction {
                case .toFront:  placedAssets[i].zIndex = maxZ + 1
                case .toBack:   placedAssets[i].zIndex = -1
                case .forward:  placedAssets[i].zIndex += 1.5
                case .backward: placedAssets[i].zIndex -= 1.5
                }
            } else if let i = placedTexts.firstIndex(where: { $0.id == id }) {
                switch direction {
                case .toFront:  placedTexts[i].zIndex = maxZ + 1
                case .toBack:   placedTexts[i].zIndex = -1
                case .forward:  placedTexts[i].zIndex += 1.5
                case .backward: placedTexts[i].zIndex -= 1.5
                }
            }
            normalizeZIndices()
        }
    }

    func normalizeZIndices() {
        let allLayers = (placedAssets.map { (id: $0.id, z: $0.zIndex, isAsset: true) } +
                         placedTexts.map { (id: $0.id, z: $0.zIndex, isAsset: false) })
            .sorted { $0.z < $1.z }

        for (i, layer) in allLayers.enumerated() {
            if layer.isAsset, let idx = placedAssets.firstIndex(where: { $0.id == layer.id }) {
                placedAssets[idx].zIndex = Double(i)
            } else if !layer.isAsset, let idx = placedTexts.firstIndex(where: { $0.id == layer.id }) {
                placedTexts[idx].zIndex = Double(i)
            }
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Font Picker Panel
// ─────────────────────────────────────────────────────────

struct FontPickerPanel: View {
    let onFontSelected: (FontOption) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Choose a Font")
                .font(.system(size: 18, weight: .bold))
                .padding(.vertical, 16)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(availableFonts) { option in
                        Button {
                            onFontSelected(option)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(option.displayName)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.secondary)
                                    Text(option.sampleText)
                                        .font(.custom(option.fontName, size: 20))
                                        .foregroundStyle(Color.brown.opacity(0.85))
                                        .lineLimit(1)
                                }
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(Color.brown.opacity(0.5))
                                    .font(.system(size: 18))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                        }
                        Divider()
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Text Edit Panel
// ─────────────────────────────────────────────────────────

struct TextEditPanel: View {
    @Binding var placedText: PlacedText
    @State private var coordinator: RichTextEditor.Coordinator? = nil

    var resolvedUIFont: UIFont {
        var descriptor = UIFontDescriptor(
            name: placedText.fontName, size: placedText.fontSize
        )
        if placedText.isBold {
            descriptor = descriptor.withSymbolicTraits(.traitBold) ?? descriptor
        }
        if placedText.isItalic {
            descriptor = descriptor.withSymbolicTraits(.traitItalic) ?? descriptor
        }
        return UIFont(descriptor: descriptor, size: placedText.fontSize)
    }

    var resolvedAlignment: NSTextAlignment {
        switch placedText.textAlignment {
        case "leading":  return .left
        case "trailing": return .right
        default:         return .center
        }
    }

    func applyBold() {
        guard let tv = coordinator?.textView,
              tv.selectedRange.length > 0 else { return }
        let range = tv.selectedRange
        coordinator?.isApplyingAttributes = true
        let mutable = NSMutableAttributedString(
            attributedString: tv.attributedText
        )
        mutable.enumerateAttribute(.font, in: range) { value, subRange, _ in
            let existing = (value as? UIFont) ?? resolvedUIFont
            let isBold = existing.fontDescriptor.symbolicTraits.contains(.traitBold)
            let traits = isBold
                ? existing.fontDescriptor.symbolicTraits.subtracting(.traitBold)
                : existing.fontDescriptor.symbolicTraits.union(.traitBold)
            let newFont = UIFont(
                descriptor: existing.fontDescriptor.withSymbolicTraits(traits)
                            ?? existing.fontDescriptor,
                size: existing.pointSize
            )
            mutable.addAttribute(.font, value: newFont, range: subRange)
        }
        tv.attributedText = mutable
        tv.selectedRange = range
        placedText.nsAttributedString = mutable
        coordinator?.isApplyingAttributes = false
    }

    func applyItalic() {
        guard let tv = coordinator?.textView,
              tv.selectedRange.length > 0 else { return }
        let range = tv.selectedRange
        coordinator?.isApplyingAttributes = true
        let mutable = NSMutableAttributedString(
            attributedString: tv.attributedText
        )
        mutable.enumerateAttribute(.font, in: range) { value, subRange, _ in
            let existing = (value as? UIFont) ?? resolvedUIFont
            let isItalic = existing.fontDescriptor.symbolicTraits.contains(.traitItalic)
            let traits = isItalic
                ? existing.fontDescriptor.symbolicTraits.subtracting(.traitItalic)
                : existing.fontDescriptor.symbolicTraits.union(.traitItalic)
            let newFont = UIFont(
                descriptor: existing.fontDescriptor.withSymbolicTraits(traits)
                            ?? existing.fontDescriptor,
                size: existing.pointSize
            )
            mutable.addAttribute(.font, value: newFont, range: subRange)
        }
        tv.attributedText = mutable
        tv.selectedRange = range
        placedText.nsAttributedString = mutable
        coordinator?.isApplyingAttributes = false
    }

    func applyColor(_ color: UIColor) {
        guard let tv = coordinator?.textView,
              tv.selectedRange.length > 0 else { return }
        let range = tv.selectedRange
        coordinator?.isApplyingAttributes = true
        let mutable = NSMutableAttributedString(
            attributedString: tv.attributedText
        )
        mutable.addAttribute(.foregroundColor, value: color, range: range)
        tv.attributedText = mutable
        tv.selectedRange = range
        // store directly as NSAttributedString — no bridging loss
        placedText.nsAttributedString = mutable
        coordinator?.isApplyingAttributes = false
    }

    func applyFontSize(_ size: CGFloat) {
        guard let tv = coordinator?.textView else { return }
        let range = tv.selectedRange
        coordinator?.isApplyingAttributes = true
        let mutable = NSMutableAttributedString(
            attributedString: tv.attributedText
        )
        let applyRange = range.length > 0
            ? range
            : NSRange(location: 0, length: mutable.length)
        mutable.enumerateAttribute(.font, in: applyRange) { value, subRange, _ in
            let existing = (value as? UIFont) ?? resolvedUIFont
            let newFont = UIFont(
                descriptor: existing.fontDescriptor,
                size: size
            )
            mutable.addAttribute(.font, value: newFont, range: subRange)
        }
        tv.attributedText = mutable
        if range.length > 0 { tv.selectedRange = range }
        placedText.nsAttributedString = mutable
        placedText.fontSize = size
        coordinator?.isApplyingAttributes = false
    }

    var body: some View {
        VStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 3)
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 6)

            RichTextEditor(
                nsAttributedString: Binding(
                    get: { placedText.nsAttributedString },
                    set: { placedText.nsAttributedString = $0 }
                ),
                coordinator: $coordinator,
                fontSize: placedText.fontSize,
                fontName: placedText.fontName,
                alignment: resolvedAlignment
            )
            .frame(height: 80)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.brown.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Divider()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {

                    Button { applyBold() } label: {
                        Text("B")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.brown)
                            .frame(width: 36, height: 36)
                            .background(Color.brown.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Button { applyItalic() } label: {
                        Text("I")
                            .font(.system(size: 18, weight: .medium).italic())
                            .foregroundStyle(Color.brown)
                            .frame(width: 36, height: 36)
                            .background(Color.brown.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Divider().frame(height: 28)

                    HStack(spacing: 8) {
                        Button {
                            applyFontSize(max(10, placedText.fontSize - 2))
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.brown)
                                .frame(width: 30, height: 30)
                                .background(Color.brown.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("\(Int(placedText.fontSize))pt")
                            .font(.system(size: 14, weight: .medium))
                            .frame(width: 44)
                        Button {
                            applyFontSize(min(120, placedText.fontSize + 2))
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.brown)
                                .frame(width: 30, height: 30)
                                .background(Color.brown.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    Divider().frame(height: 28)

                    HStack(spacing: 4) {
                        ForEach([
                            ("text.alignleft",   "leading"),
                            ("text.aligncenter", "center"),
                            ("text.alignright",  "trailing")
                        ], id: \.1) { icon, alignment in
                            Button {
                                placedText.textAlignment = alignment
                            } label: {
                                Image(systemName: icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(
                                        placedText.textAlignment == alignment
                                            ? Color.brown : Color.secondary
                                    )
                                    .frame(width: 32, height: 32)
                                    .background(
                                        placedText.textAlignment == alignment
                                            ? Color.brown.opacity(0.15) : Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }

                    Divider().frame(height: 28)

                    ColorPicker("", selection: Binding(
                        get: { Color(hex: placedText.colorHex) },
                        set: { newColor in
                            let ui = UIColor(newColor)
                            var r: CGFloat = 0, g: CGFloat = 0
                            var b: CGFloat = 0, a: CGFloat = 0
                            ui.getRed(&r, green: &g, blue: &b, alpha: &a)
                            placedText.colorHex = String(
                                format: "#%02X%02X%02X",
                                Int(r * 255), Int(g * 255), Int(b * 255)
                            )
                            applyColor(ui)
                        }
                    ), supportsOpacity: false)
                    .labelsHidden()
                    .frame(width: 36, height: 36)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Rich Text Editor
// ─────────────────────────────────────────────────────────

struct RichTextEditor: UIViewRepresentable {
    @Binding var nsAttributedString: NSAttributedString
    @Binding var coordinator: Coordinator?
    var fontSize: CGFloat
    var fontName: String
    var alignment: NSTextAlignment

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.textAlignment = alignment
        tv.delegate = context.coordinator
        tv.tintColor = UIColor.systemBlue
        context.coordinator.textView = tv
        DispatchQueue.main.async {
            self.coordinator = context.coordinator
        }
        tv.attributedText = nsAttributedString
        tv.typingAttributes = [
            .font: UIFont(name: fontName, size: fontSize)
                   ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.label
        ]
        return tv
    }

    func updateUIView(_ tv: UITextView, context: Context) {
        guard !(coordinator?.isApplyingAttributes ?? false) else { return }
        if tv.attributedText.string != nsAttributedString.string {
            let sel = tv.selectedRange
            tv.attributedText = nsAttributedString
            if sel.location <= tv.attributedText.length {
                tv.selectedRange = sel
            }
        }
        tv.textAlignment = alignment
        tv.typingAttributes = [
            .font: UIFont(name: fontName, size: fontSize)
                   ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.label
        ]
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        weak var textView: UITextView?
        var isApplyingAttributes = false

        init(_ parent: RichTextEditor) { self.parent = parent }

        var selectedRange: NSRange {
            textView?.selectedRange ?? NSRange(location: 0, length: 0)
        }

        func textViewDidChange(_ tv: UITextView) {
            guard !isApplyingAttributes else { return }
            parent.nsAttributedString = tv.attributedText
        }
    }
}
// ─────────────────────────────────────────────────────────
// MARK: - Draggable Asset/Text
// ─────────────────────────────────────────────────────────

struct DraggableAsset: View {
    @Binding var asset: PlacedAsset
    let onDelete: () -> Void
    let onSelect: () -> Void

    @GestureState private var dragState = CGSize.zero
    @GestureState private var handleDragState = CGSize.zero
    @GestureState private var rotateDragState: Angle = .zero
    @State private var imageSize: CGSize = .zero

    var handleScaleDelta: CGFloat {
        let delta = handleDragState.width - handleDragState.height
        return max(0.2, 1 + delta / 200)
    }

    var body: some View {
        // image only — this gets clipped by the page
        Group {
            if let uiImage = asset.importedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            } else {
                Image(asset.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
        }
        .scaleEffect(
            x: asset.isFlippedH ? -1 : 1,
            y: asset.isFlippedV ? -1 : 1
        )
        .animation(.easeInOut(duration: 0.4), value: asset.isFlippedH)
        .animation(.easeInOut(duration: 0.4), value: asset.isFlippedV)
        .background(
            GeometryReader { geo in
                Color.clear.onAppear { imageSize = geo.size }
            }
        )
        // handles are in an overlay — not clipped by the page
        .overlay {
            if asset.isSelected {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundStyle(Color.blue.opacity(0.6))
                        .frame(width: imageSize.width, height: imageSize.height)

                    controlButton(icon: "trash", color: .red) {
                        onDelete()
                    }
                    .offset(x: -imageSize.width / 2, y: -imageSize.height / 2)

                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(Color.blue.opacity(0.6), lineWidth: 2))
                        .overlay(
                            Image(systemName: "rotate.right")
                                .font(.system(size: 10))
                                .foregroundStyle(Color.blue)
                        )
                        .frame(width: 22, height: 22)
                        .offset(y: -imageSize.height / 2 - 20)
                        .gesture(
                            DragGesture()
                                .updating($rotateDragState) { value, state, _ in
                                    state = .degrees(value.translation.width / 2)
                                }
                                .onEnded { value in
                                    asset.rotation += .degrees(value.translation.width / 2)
                                }
                        )

                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(Color.blue.opacity(0.6), lineWidth: 2))
                        .overlay(
                            Image(systemName: "arrow.down.left.and.arrow.up.right")
                                .font(.system(size: 10))
                                .foregroundStyle(Color.blue)
                        )
                        .frame(width: 22, height: 22)
                        .offset(x: imageSize.width / 2, y: -imageSize.height / 2)
                        .gesture(
                            DragGesture()
                                .updating($handleDragState) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    let delta = value.translation.width - value.translation.height
                                    asset.scale = max(0.2, asset.scale * max(0.2, 1 + delta / 200))
                                }
                        )

                    controlButton(
                        icon: "arrow.left.and.right.righttriangle.left.righttriangle.right",
                        color: .blue
                    ) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            asset.isFlippedH.toggle()
                        }
                    }
                    .offset(x: -imageSize.width / 4, y: imageSize.height / 2 + 20)

                    controlButton(
                        icon: "arrow.up.and.down.righttriangle.up.righttriangle.down",
                        color: .blue
                    ) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            asset.isFlippedV.toggle()
                        }
                    }
                    .offset(x: imageSize.width / 4, y: imageSize.height / 2 + 20)
                }
            }
        }
        .rotationEffect(asset.rotation + rotateDragState)
        .scaleEffect(asset.scale * (asset.isSelected ? handleScaleDelta : 1.0))
        .offset(
            CGSize(
                width: asset.offset.width + dragState.width,
                height: asset.offset.height + dragState.height
            )
        )
        .onTapGesture {
            onSelect()
            withAnimation(.easeInOut(duration: 0.15)) {
                asset.isSelected.toggle()
            }
        }
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    asset.offset = CGSize(
                        width: asset.offset.width + value.translation.width,
                        height: asset.offset.height + value.translation.height
                    )
                }
        )
    }

    @ViewBuilder
    func controlButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(color.opacity(0.6), lineWidth: 2))
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 10))
                        .foregroundStyle(color)
                )
                .frame(width: 22, height: 22)
        }
    }
}


struct DraggableText: View {
    @Binding var placedText: PlacedText
    let onDelete: () -> Void
    let onSelect: () -> Void

    @GestureState private var dragState = CGSize.zero
    @GestureState private var rotateDragState: Angle = .zero
    @GestureState private var widthDragState: CGFloat = 0
    @State private var textSize: CGSize = .zero

    var resolvedFont: Font {
        let base = Font.custom(placedText.fontName, size: placedText.fontSize)
        if placedText.isBold && placedText.isItalic { return base.bold().italic() }
        if placedText.isBold { return base.bold() }
        if placedText.isItalic { return base.italic() }
        return base
    }

    var resolvedAlignment: TextAlignment {
        switch placedText.textAlignment {
        case "leading": return .leading
        case "trailing": return .trailing
        default: return .center
        }
    }

    var currentWidth: CGFloat {
        max(80, placedText.width + widthDragState)
    }

    var body: some View {
        ZStack {
            // ── Text ──────────────────────────────────────
            Text(placedText.attributedString)
                .font(resolvedFont)
                .foregroundStyle(Color(hex: placedText.colorHex))
                .multilineTextAlignment(resolvedAlignment)
                .frame(width: currentWidth, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { textSize = geo.size }
                            .onChange(of: geo.size) { _, newSize in
                                textSize = newSize
                            }
                    }
                )

            if placedText.isSelected {
                // ── Dashed box ────────────────────────────
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundStyle(Color.blue.opacity(0.6))
                    .frame(width: textSize.width + 16, height: textSize.height + 12)

                // ── Delete — top left ─────────────────────
                controlButton(icon: "trash", color: .red) {
                    placedText.isSelected = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        onDelete()
                    }
                }
                .offset(
                    x: -(textSize.width + 16) / 2,
                    y: -(textSize.height + 12) / 2
                )

                // ── Rotate — top centre ───────────────────
                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.blue.opacity(0.6), lineWidth: 2))
                    .overlay(
                        Image(systemName: "rotate.right")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.blue)
                    )
                    .frame(width: 22, height: 22)
                    .offset(y: -(textSize.height + 12) / 2 - 20)
                    .gesture(
                        DragGesture()
                            .updating($rotateDragState) { value, state, _ in
                                state = .degrees(value.translation.width / 2)
                            }
                            .onEnded { value in
                                placedText.rotation += .degrees(value.translation.width / 2)
                            }
                    )

                // ── Width handle — right side ─────────────
                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.blue.opacity(0.6), lineWidth: 2))
                    .overlay(
                        Image(systemName: "arrow.left.and.right")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.blue)
                    )
                    .frame(width: 22, height: 22)
                    .offset(x: (textSize.width + 16) / 2)
                    .gesture(
                        DragGesture()
                            .updating($widthDragState) { value, state, _ in
                                state = value.translation.width * 2
                            }
                            .onEnded { value in
                                placedText.width = max(80, placedText.width + value.translation.width * 2)
                            }
                    )
            }
        }
        .scaleEffect(placedText.scale)
        .rotationEffect(placedText.rotation + rotateDragState)
        .offset(CGSize(
            width: placedText.offset.width + dragState.width,
            height: placedText.offset.height + dragState.height
        ))
        .onTapGesture {
            onSelect()
            withAnimation(.easeInOut(duration: 0.15)) {
                placedText.isSelected.toggle()
            }
        }
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in state = value.translation }
                .onEnded { value in
                    placedText.offset = CGSize(
                        width: placedText.offset.width + value.translation.width,
                        height: placedText.offset.height + value.translation.height
                    )
                }
        )
    }

    @ViewBuilder
    func controlButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(color.opacity(0.6), lineWidth: 2))
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 10))
                        .foregroundStyle(color)
                )
                .frame(width: 22, height: 22)
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Preset Panel
// ─────────────────────────────────────────────────────────

struct PresetPanelView: View {
    let category: AssetCategory
    @Binding var openSubcategory: AssetSubcategory?
    @Binding var customSubcategories: [AssetSubcategory]
    var importedImages: [String: UIImage] = [:]
    let onAssetTapped: (AssetItem) -> Void
    let onImageImported: (UIImage, String, String) -> Void
    let onDeleteSubcategory: (String) -> Void
    let onRenameSubcategory: (String, String) -> Void
    let onDeleteAsset: (String, String) -> Void
    let onRenameAsset: (String, String) -> Void

    @State private var photoPickerItem: PhotosPickerItem? = nil
    @State private var showingNewSubcategoryAlert = false
    @State private var newSubcategoryName = ""
    @State private var subcategoryToEdit: AssetSubcategory? = nil
    @State private var showingEditSubcategoryAlert = false
    @State private var editedName = ""
    @State private var pendingImage: UIImage? = nil
    @State private var pendingSubcategoryID: String = ""
    @State private var showingNameImageAlert = false
    @State private var newImageName = ""
    @State private var assetToEdit: AssetItem? = nil
    @State private var showingRenameAssetAlert = false
    @State private var editedAssetName = ""

    var builtInSubcategories: [AssetSubcategory] {
        AssetLibrary.subcategories.filter { $0.category == category }
    }

    var customSubcategoriesForCategory: [AssetSubcategory] {
        customSubcategories.filter { $0.category == category }
    }

    var allSubcategories: [AssetSubcategory] {
        builtInSubcategories + customSubcategoriesForCategory
    }
    // check if this subcategory is a custom one
    var isCustomSubcategory: Bool {
        customSubcategories.contains(where: { $0.id == openSubcategory?.id })
    }

    var body: some View {
        VStack(spacing: 0) {

            HStack {
                Text(openSubcategory?.name ?? category.rawValue)
                    .font(.title2.bold())

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        openSubcategory = nil
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .opacity(openSubcategory != nil ? 1 : 0)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)

            Divider()

            ScrollView {
                if let sub = openSubcategory {

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(sub.assets) { asset in
                            AssetThumbnail(asset: asset, importedImages: importedImages)
                                .onTapGesture { onAssetTapped(asset) }
                                .contextMenu {
                                    Button {
                                        assetToEdit = asset
                                        editedAssetName = asset.displayName
                                        showingRenameAssetAlert = true
                                    } label: {
                                        Label("Rename", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        onDeleteAsset(sub.id, asset.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                        
                        if isCustomSubcategory {
                            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                                ImportTile(label: "Add image")
                            }
                            .onChange(of: photoPickerItem) { _, newItem in
                                Task {
                                    if let newItem,
                                       let data = try? await newItem.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        pendingImage = image
                                        pendingSubcategoryID = sub.id
                                        newImageName = ""
                                        showingNameImageAlert = true
                                        photoPickerItem = nil
                                    }
                                }
                            }
                        }
                    }
                    .padding(12)
                    .transition(.move(edge: .trailing).combined(with: .opacity))

                } else {

                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(allSubcategories) { sub in
                            SubcategoryThumbnail(subcategory: sub, importedImages: importedImages)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        openSubcategory = sub
                                    }
                                }
                                .contextMenu {
                                    if customSubcategories.contains(where: { $0.id == sub.id }) {
                                        Button {
                                            subcategoryToEdit = sub
                                            editedName = sub.name
                                            showingEditSubcategoryAlert = true
                                        } label: {
                                            Label("Rename", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) {
                                            onDeleteSubcategory(sub.id)
                                        } label: {
                                            Label("Delete group", systemImage: "trash")
                                        }
                                    }
                                }
                        }

                        Button {
                            showingNewSubcategoryAlert = true
                        } label: {
                            ImportTile(label: "New group")
                        }
                    }
                    .padding(12)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
        .alert("Rename group", isPresented: $showingEditSubcategoryAlert) {
            TextField("Group name", text: $editedName)
            Button("Save") {
                if let sub = subcategoryToEdit,
                   !editedName.trimmingCharacters(in: .whitespaces).isEmpty {
                    onRenameSubcategory(sub.id, editedName)
                }
                editedName = ""
                subcategoryToEdit = nil
            }
            Button("Cancel", role: .cancel) {
                editedName = ""
                subcategoryToEdit = nil
            }
        } message: { Text("Enter a new name") }
        .alert("Rename asset", isPresented: $showingRenameAssetAlert) {
            TextField("Asset name", text: $editedAssetName)
            Button("Save") {
                if let asset = assetToEdit,
                   !editedAssetName.trimmingCharacters(in: .whitespaces).isEmpty {
                    onRenameAsset(asset.id, editedAssetName)
                }
                assetToEdit = nil
                editedAssetName = ""
            }
            Button("Cancel", role: .cancel) {
                assetToEdit = nil
                editedAssetName = ""
            }
        } message: { Text("Enter a new name for this asset") }
        .alert("New group", isPresented: $showingNewSubcategoryAlert) {
            TextField("e.g. My Bunny", text: $newSubcategoryName)
            Button("Create") {
                guard !newSubcategoryName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                let newSub = AssetSubcategory(
                    id: UUID().uuidString,
                    name: newSubcategoryName,
                    category: category,
                    assets: []
                )
                withAnimation { customSubcategories.append(newSub) }
                newSubcategoryName = ""
            }
            Button("Cancel", role: .cancel) { newSubcategoryName = "" }
        } message: { Text("Give your group a name") }
        .alert("Name this asset", isPresented: $showingNameImageAlert) {
            TextField("e.g. Sitting", text: $newImageName)
            Button("Add") {
                guard !newImageName.trimmingCharacters(in: .whitespaces).isEmpty,
                      let image = pendingImage else { return }
                let subID = pendingSubcategoryID
                let name = newImageName
                onImageImported(image, subID, name)
                pendingImage = nil
                pendingSubcategoryID = ""
                newImageName = ""
                // give SwiftUI one tick to propagate the update, then refresh the open subcategory
                DispatchQueue.main.async {
                    if let updated = customSubcategories.first(where: { $0.id == subID }) {
                        openSubcategory = updated
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                pendingImage = nil
                pendingSubcategoryID = ""
                newImageName = ""
            }
        } message: { Text("Give this asset a name") }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Reusable Tile Views
// ─────────────────────────────────────────────────────────

struct SubcategoryThumbnail: View {
    let subcategory: AssetSubcategory
    var importedImages: [String: UIImage] = [:]

    // first asset name to use as thumbnail preview
    var previewImageName: String? {
        subcategory.assets.first?.name
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // background rectangle always shows
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.brown.opacity(0.12))
                    .frame(height: 110)

                // imported image takes priority
                if let firstAsset = subcategory.assets.first,
                   let uiImage = importedImages[firstAsset.id] {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                // then try named asset from xcassets
                } else if let name = previewImageName,
                          UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                // fallback text if no image found
                } else {
                    Text(subcategory.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 2) {
                Text(subcategory.name)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                if !subcategory.description.isEmpty {
                    Text(subcategory.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(minHeight: 44, alignment: .top)
        }
    }
}

struct AssetThumbnail: View {
    let asset: AssetItem
    var importedImages: [String: UIImage] = [:]

    var body: some View {
        VStack(spacing: 6) {
            Group {
                if let uiImage = importedImages[asset.id] {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(asset.name)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(spacing: 2) {
                Text(asset.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.primary)

                if !asset.description.isEmpty {
                    Text(asset.description)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(minHeight: 44, alignment: .top)  // same height for all tiles
        }
    }
}

struct ImportTile: View {
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.brown.opacity(0.06))
                .frame(height: 110)
                .overlay(
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(Color.brown.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1.5, dash: [4])
                        )
                        .foregroundStyle(Color.brown.opacity(0.25))
                )
            // same fixed height text area as other tiles
            VStack(spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(minHeight: 44, alignment: .top)
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Category Bar
// ─────────────────────────────────────────────────────────

struct CategoryBar: View {
    @Binding var openCategory: AssetCategory?
    @Binding var openSubcategory: AssetSubcategory?
    var onTextTapped: (() -> Void)? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AssetCategory.allCases, id: \.self) { category in
                    Button {
                        if category == .text {
                            openCategory = nil
                            openSubcategory = nil
                            onTextTapped?()
                        } else {
                            withAnimation(.spring(duration: 0.3)) {
                                if openCategory == category {
                                    openCategory = nil
                                    openSubcategory = nil
                                } else {
                                    openCategory = category
                                    openSubcategory = nil
                                }
                            }
                        }
                    } label: {
                        Text(category.rawValue)
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(
                                openCategory == category
                                    ? Color(red: 0.85, green: 0.72, blue: 0.55).opacity(0.85)       // dark brown when active
                                    : Color(red: 0.10, green: 0.07, blue: 0.04).opacity(0.25)  // warm tan when inactive
                            )
                            .foregroundStyle(
                                openCategory == category
                                    ? Color(red: 0.25, green: 0.12, blue: 0.02)    // gold text when active
                                    : Color(red: 0.85, green: 0.72, blue: 0.5) // dark brown text when inactive
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
        }
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Color Picker
// ─────────────────────────────────────────────────────────

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// ─────────────────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────────────────

#Preview(traits: .landscapeLeft) {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
