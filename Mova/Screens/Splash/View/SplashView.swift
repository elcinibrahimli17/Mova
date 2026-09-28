//
//  SplashView.swift
//  Mova
//
//  Created by Elchın on 03.09.26.
//

import SwiftUI

struct SplashView: View {
    private let letters = Array("Mova")
    @State private var visibleCount = 0
    @State private var glowScale: CGFloat = 0.5
    @State private var glowOpacity: Double = 0
    @State private var logoScale: CGFloat = 1.0
    
    var body: some View {
        splash
            .onAppear {
                animateLetters()
                animateGlow()
            }
    }
    
    var splash: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 200) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.red.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 160
                            )
                        )
                        .frame(width: 320, height: 320)
                        .scaleEffect(glowScale)
                        .opacity(glowOpacity)
                        .blur(radius: 10)
                    
                    HStack(spacing: 2) {
                        ForEach(letters.indices, id: \.self) { index in
                            Text(String(letters[index]))
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.red)
                                .opacity(index < visibleCount ? 1 : 0)
                                .offset(y: index < visibleCount ? 0 : 12)
                                .scaleEffect(index < visibleCount ? 1 : 0.6)
                                .animation(
                                    .spring(response: 0.45, dampingFraction: 0.55),
                                    value: visibleCount
                                )
                        }
                    }
                    .scaleEffect(logoScale)
                }
                
                ProgressView()
                    .scaleEffect(2)
                    .tint(.red)
                
                Spacer()
            }
        }
    }
    
    private func animateLetters() {
        for index in 1...letters.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                visibleCount = index
                
                if index == letters.count {
                    animatePulse()
                }
            }
        }
    }
    
    private func animateGlow() {
        withAnimation(.easeOut(duration: 0.6)) {
            glowOpacity = 1
            glowScale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeIn(duration: 0.8)) {
                glowOpacity = 0
            }
        }
    }
    
    private func animatePulse() {
        withAnimation(.easeInOut(duration: 0.25)) {
            logoScale = 1.12
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeInOut(duration: 0.25)) {
                logoScale = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}
