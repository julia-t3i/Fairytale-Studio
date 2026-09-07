//
//  IntroView.swift
//  Fairytale Studio
//
//  Created by Julia Teixeira on 2026-08-16.
//

import Foundation
import SwiftUI
import SwiftData
import PhotosUI

// ─────────────────────────────────────────────────────────
// MARK: - Intro Screen
// ─────────────────────────────────────────────────────────

struct IntroView: View {
    @AppStorage("musicVolume") private var musicVolume: Double = 1.0
    @AppStorage("effectsVolume") private var effectsVolume: Double = 1.0
    
    let onStart: () -> Void
    @State private var showingSettings = false
    @State private var animateIn = false
    @State private var startPressed = false
    @State private var settingsPressed = false

    var body: some View {
        ZStack {
            // ── Full screen background ────────────────────
            Image("intro_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            GeometryReader { geo in
                // ── Buttons — bottom right area ───────────────
                VStack(spacing: 20) {
                    // Start button
                    Button {
                        // brief press animation then transition
                        withAnimation(.easeInOut(duration: 0.1)) {
                            startPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                startPressed = false
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.easeInOut(duration: 0.9)) {
                                onStart()
                            }
                        }
                    } label: {
                        Image("start_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                            .overlay(
                                // dark press flash
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(startPressed ? 0.25 : 0))
                                    .padding(.horizontal, 26)  // shrink inward horizontally
                                    .padding(.vertical, 26)     // shrink inward vertically
                            )
                            .scaleEffect(startPressed ? 0.95 : 1.0)
                            .contentShape(RoundedRectangle(cornerRadius: 16)
                                .size(width: 240, height: 68))
                    }
                    .buttonStyle(.plain)
                    
                    // Settings button
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            settingsPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                settingsPressed = false
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            showingSettings = true
                        }
                    } label: {
                        Image("settings_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(settingsPressed ? 0.25 : 0))
                                    .padding(.horizontal, 26)  // shrink inward horizontally
                                    .padding(.vertical, 26)     // shrink inward vertically
                            )
                            .scaleEffect(settingsPressed ? 0.95 : 1.0)
                            .offset(y: -40)
                            .contentShape(RoundedRectangle(cornerRadius: 16)
                                .size(width: 240, height: 68))
                    }
                    .buttonStyle(.plain)
                }
                // position buttons in the lower right
                // adjust these values to match (^ trailing = left, ^ bottom = up)
                //            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                //            .padding(.trailing, 220)
                //            .padding(.bottom, 150)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, geo.size.width * 0.17)   // ~220/1366
                .padding(.bottom, geo.size.height * 0.15)    // ~150/1024
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)
            }
            
            if showingSettings {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            showingSettings = false
                        }
                    }

                ZStack(alignment: .topTrailing) {
                    Image("settings_panel")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 480)

                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            showingSettings = false
                        }
                    } label: {
                        Color.clear.frame(width: 60, height: 60)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)

                    VStack(alignment: .leading, spacing: 73) {
                        CustomSlider(value: $musicVolume, sliderWidth: 220) { newVal in
                            AudioManager.shared.setMusicVolume(Float(newVal))
                        }
                        CustomSlider(value: $effectsVolume, sliderWidth: 220) { _ in }
                    }
                    .padding(.top, 183)
                    .padding(.leading, 180)
                    .frame(width: 480, alignment: .leading)
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                animateIn = true
            }
        }
        
    }
}



// ─────────────────────────────────────────────────────────
// MARK: - Custom Slider
// ─────────────────────────────────────────────────────────

struct CustomSlider: View {
    @Binding var value: Double
    var sliderWidth: CGFloat = 220
    var onChange: (Double) -> Void = { _ in }

    let thumbSize: CGFloat = 28

    var body: some View {
        ZStack(alignment: .leading) {
            // brown — full width underneath
            Image("settings_sliderbar_brown")
                .resizable()
                .frame(width: sliderWidth, height: 28)

            // gold — grows from left, width = value * sliderWidth
            Image("settings_sliderbar_gold")
                .resizable()
                .frame(width: sliderWidth, height: 28)
                .mask(alignment: .leading) {
                    Rectangle()
                        .frame(width: CGFloat(value) * sliderWidth)
                }

            // circle sits at right edge of gold bar
            Image("settings_slidercircle")
                .resizable()
                .frame(width: 36, height: 36)
                .offset(x: CGFloat(value) * (sliderWidth - thumbSize))
        }
        .frame(width: sliderWidth, height: thumbSize)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { drag in
                    let clamped = min(max(0, drag.location.x), sliderWidth)
                    value = Double(clamped / sliderWidth)
                    onChange(value)
                }
        )
    }
}
