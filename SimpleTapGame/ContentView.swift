//
//  ContentView.swift
//  SimpleTapGame
//
//  Created by Sergey Dolgikh on 10.07.2023.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    @State private var size: CGFloat = 40
    @State private var isEndGame: Bool = false
    @State private var startDate: Date?
    @State private var players: Set<AVAudioPlayer> = []
    @State private var donePlayer: AVAudioPlayer?
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let maxSize = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
                .frame(width: size, height: size, alignment: .center)
                .animation(.default, value: size)
            
            Button(action: pressed) {
                Color(.clear)
            }
            .ignoresSafeArea()
        }
        .onReceive(timer) { _ in
            guard !isEndGame else { return }
            guard size > 40 else { return }
            
            let newSize = size - 20
            size = newSize < 40 ? 40 : newSize
        }
        .alert("GAME OVER", isPresented: $isEndGame, actions: {
            Button("Ok") {
                size = 40
                startDate = nil
            }
        }, message: {
            Text("Yo time: \(getGameTime())")
        })
    }
}

extension ContentView {
    
    func pressed() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        play()
        if startDate == nil {
            startDate = Date()
        }
        
        if size <= maxSize {
            size += 40
        } else {
            playFinal()
            size = 3000
            isEndGame = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func getGameTime() -> String {
        guard let startDate else { return "" }
        
        let dateComponents = Calendar.current.dateComponents(
            [.second, .nanosecond],
            from: startDate,
            to: Date()
        )
        let second = dateComponents.second ?? 0
        let nanosecond = dateComponents.nanosecond ?? 0
        
        return "\(second).\(nanosecond) seconds"
    }
    
    func play() {
        let findingPlayer = players.first { !$0.isPlaying }
        
        if let findingPlayer = findingPlayer {
            findingPlayer.play()
        } else if let soundFileURL = Bundle.main.url(forResource: "prosto-chpok",
                                                     withExtension: "mp3"),
                  let newPlayer = try? AVAudioPlayer(contentsOf: soundFileURL) {
            
            players.insert(newPlayer)
            newPlayer.play()
        }
    }
    
    func playFinal() {
        if let donePlayer {
            donePlayer.play()
        } else if let soundFileURL = Bundle.main.url(forResource: "applepay",
                                                     withExtension: "mp3"),
                  let newPlayer = try? AVAudioPlayer(contentsOf: soundFileURL) {
            donePlayer = newPlayer
            newPlayer.play()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
