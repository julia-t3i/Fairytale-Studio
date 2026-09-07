//
//  Fairytale_StudioApp.swift
//  Fairytale Studio
//
//  Created by Julia Teixeira on 2026-06-08.
//

import SwiftUI
import SwiftData

@main
struct Fairytale_StudioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self) 
    }
}
