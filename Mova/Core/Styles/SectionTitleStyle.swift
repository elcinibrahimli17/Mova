//
//  SectionTitleStyle.swift
//  Mova
//
//  Created by Elchın on 09.09.26.
//


import SwiftUI

struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black)
    }
}

extension View {
    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }
}