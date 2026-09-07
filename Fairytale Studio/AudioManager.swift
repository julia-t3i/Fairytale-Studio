//
//  AudioManager.swift
//  Fairytale Studio
//
//  Created by Julia Teixeira on 2026-08-29.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    var musicPlayer: AVAudioPlayer?

    func startMusic() {
        guard musicPlayer == nil else { return }
        if let url = Bundle.main.url(forResource: "Imagination", withExtension: "wav") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
            } catch {
                print("Music failed to load: \(error)")
            }
        }
    }

    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
    }
}
