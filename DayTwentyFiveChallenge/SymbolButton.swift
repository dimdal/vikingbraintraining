//
//  SymbolButton.swift
//  DayTwentyFiveChallenge
//
//  Created by Marius Ørvik on 06/02/2024.
//

import SwiftUI

struct SymbolButton: View {
    var buttonVariation: String
    var buttonColor: Color
    
    // Translate Norwegian and Swedish to English
    private var translatedVariation: String {
        switch buttonVariation {
        case "stein", "sten": // Norwegian and Swedish for "rock"
            return "rock"
        case "papir", "påse": // Norwegian and Swedish for "paper"
            return "paper"
        case "saks", "sax": // Norwegian and Swedish for "scissors"
            return "scissors"
        default:
            return buttonVariation // Assumes default is already in English or an unsupported language
        }
    }
    
    init(_ buttonVariation: String = "sax", color: Color = .red) {
        self.buttonVariation = buttonVariation
        self.buttonColor = color
    }
    
    var body: some View {
        VStack {
            Image(translatedVariation)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .cornerRadius(20)
            Text(buttonVariation)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(buttonColor)
        }
    }
}


#Preview {
    SymbolButton()
}
