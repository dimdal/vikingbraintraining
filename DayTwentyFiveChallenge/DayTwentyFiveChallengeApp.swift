//
//  DayTwentyFiveChallengeApp.swift
//  DayTwentyFiveChallenge
//
//  Created by Marius Ørvik on 04/02/2024.
//

import SwiftUI

@main
struct DayTwentyFiveChallengeApp: App {
    @State private var showLanguageSelection = true
    @State private var selectedLanguage = "English" // Default language
    var body: some Scene {
        WindowGroup {
            if showLanguageSelection {
                LanguageSelectionView(isPresented: $showLanguageSelection, selectedLanguage: $selectedLanguage)
            } else {
                ContentView(currentLanguage: selectedLanguage)
            }
        }
    }
}
