//
//  LanguageSelectionView.swift
//  DayTwentyFiveChallenge
//
//  Created by Marius Ørvik on 15/02/2024.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Binding var isPresented: Bool
    @Binding var selectedLanguage: String

    let languages = [
        ("Norwegian", "🇳🇴"),
        ("English", "🇬🇧"),
        ("Swedish", "🇸🇪")
    ]

    var body: some View {
        NavigationView {
            List(languages, id: \.0) { language, flag in
                Button(action: {
                    selectedLanguage = language
                    isPresented = false // Dismiss the language selection view
                }) {
                    HStack {
                        Text(flag)
                            .font(.largeTitle)
                        Text(language)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Choose Language")
        }
    }
}

