//
//  ContentView.swift
//  DayTwentyFiveChallenge
//
//  Created by Marius Ørvik on 04/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentLanguage: String
    
    private var possibleMoves: [String] {
        switch currentLanguage {
        case "Norwegian":
            return ["stein", "papir", "saks"]
        case "Swedish":
            return ["sten", "påse", "sax"]
        default: // English
            return ["rock", "paper", "scissors"]
        }
    }
    
    private var winningMoves: [String] {
        switch currentLanguage {
        case "Norwegian":
            return ["papir", "saks", "stein"]
        case "Swedish":
            return ["påse", "sax", "sten"]
        default: // English
            return ["paper", "scissors", "rock"]
        }
    }
    
    init(currentLanguage: String) {
        self._currentLanguage = State(initialValue: currentLanguage)
    }
    
    private let numberOfRounds = 10
    @State private var currentCpuMove: String = ""
    @State private var gameRound = 1
    @State private var score = 0
    
    @State private var gameRoundSummary: String?
    @State private var roundWon = false
    @State private var waitingForNextRound = false
    @State private var gameEnded = false
    
    @State private var win = Bool.random()
    @State private var timerCount: Int = 10
    @State private var interRoundCountdown: Int = 5
    
    // creates a new timer object that updates every 1 second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            Image("woodBackground")
                .resizable()
                .ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    
                    if !gameEnded {
                        VStack {
                            Text("Score: \(score)")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("Round \(gameRound) of \(numberOfRounds)")
                        }
                    }
                    
                    Spacer()
                    
                    // CPU's move and win/lose condition
                    if !waitingForNextRound && !gameEnded {
                        if timerCount > 0 {
                            VStack {
                                Text("CPU Plays")
                                    .font(.largeTitle)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding()
                                SymbolButton(currentCpuMove, color: .white)
                                
                                Text("Your goal is to \(win ? "Win" : "Lose")")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .padding()
                            .background(win ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                            .cornerRadius(30)
                        } else {
                            Text("Time is up!")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    
                    if waitingForNextRound && !gameEnded {
                        Text("\(roundWon ? "Correct!" : "Incorrect!")")
                            .font(.largeTitle)
                            .foregroundColor(roundWon ? .green : .red)
                        Text("New round starting in \(interRoundCountdown)s")
                    }
                    
                    if gameEnded {
                        VStack {
                            
                            Text("Game Over!")
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            Text("Final score: \(score)")
                            
                            Button(action: newGame) {
                                Label("New Game", systemImage: "star")
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(.black)
                            .padding()
                        }
                    }
                    
                    
                    Spacer()
                    
                }
                .padding()
                .onAppear {
                    initializeGameState()
                }
                
                // Countdown timer
                VStack {
                    if !waitingForNextRound && !gameEnded {
                        
                        if timerCount > 0 {
                            Text("\(timerCount)s")
                                .font(.largeTitle)
                                .foregroundStyle(timerCount > 3 ? .black : .red)
                                .transition(.opacity)
                                .animation(.easeInOut, value: timerCount)
                        }
                        
                    }
                }
                .onReceive(timer) { _ in
                    if waitingForNextRound {
                        if interRoundCountdown > 0 {
                            interRoundCountdown -= 1
                        }
                        if interRoundCountdown == 0 {
                            waitingForNextRound = false
                            resetGame() // Call resetGame when inter-round countdown finishes
                        }
                    } else if !gameEnded {
                        if timerCount > 0 {
                            timerCount -= 1
                        }
                        // Moved the gameEnded condition inside the else block to prevent ending the game during waitingForNextRound
                        if timerCount == 0 && !waitingForNextRound {
                            gameEnded = true
                        }
                    }
                }
                
                
                // Player controls
                if !gameEnded {
                    VStack {
                        
                        HStack {
                            
                            Spacer()
                            
                            ForEach(possibleMoves, id: \.self) { move in
                                Button {
                                    waitingForNextRound ? nil : submitMove(move)
                                } label: {
                                    SymbolButton(move, color: .black)
                                }
                                Spacer()
                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                }
            }
            
        }
        
    }
    
    func submitMove(_ playerMove: String) {
        
        // Attempt to find the index of the current CPU move within the predefined list of possible moves.
        if let index = possibleMoves.firstIndex(of: currentCpuMove) {
            
            // Check if the player's move matches the winning move for the CPU's move index. The winningMoves array is parallel to possibleMoves, meaning each index corresponds to a winning response to the CPU's move. If the player's move matches and the win condition is true, declare the player as the winner.
            
            if win {
                if playerMove == winningMoves[index] {
                    roundWon = true
                    score += 1
                } else {
                    roundWon = false
                    score -= 1
                }
            }
            
            if !win {
                if playerMove != winningMoves[index] {
                    roundWon = true
                    score += 1
                } else {
                    roundWon = false
                    score -= 1
                }
            }
            
        }
        
        countDownNewRound()
        
    }
    
    func countDownNewRound() {
        
        if gameRound >= numberOfRounds {
            gameEnded = true
            waitingForNextRound = false
        }
        
        // Show countdown before starting a new round
        waitingForNextRound = true
        interRoundCountdown = 5 // Set countdown duration to 5 seconds
    }
    
    func resetGame() {
        currentCpuMove = possibleMoves[Int.random(in: 0...2)]
        win.toggle()
        gameRound += 1
        waitingForNextRound = false
        timerCount = 10
    }
    
    func newGame() {
        gameRound = 0
        score = 0
        gameEnded = false
        resetGame()
    }
    
    private func initializeGameState() {
        currentCpuMove = possibleMoves[Int.random(in: 0...2)] // Now correctly using possibleMoves based on the current language
        // Initialize other parts of your game state as needed
    }
    
}

#Preview {
    ContentView(currentLanguage: "Swedish")
}
