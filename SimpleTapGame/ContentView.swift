//
//  ContentView.swift
//  SimpleTapGame
//
//  Created by Sergey Dolgikh on 10.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var size: CGFloat = 40
    @State private var isEndGame: Bool = false
    @State private var startDate: Date?
    
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
            size -= 20
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
        
        if startDate == nil {
            startDate = Date()
        }
        
        if size < maxSize {
            size += 50
        } else {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
