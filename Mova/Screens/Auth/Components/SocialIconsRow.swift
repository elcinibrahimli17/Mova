//
//  SocialIconsRow.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct SocialIconsRow: View {
    var filled: Bool = false 

    var body: some View {
        HStack(spacing: 16) {
            CircleSocialButton(icon: "facebook", isSystemIcon: false, backgroundColor: filled ? .white : nil)
            CircleSocialButton(icon: "google", isSystemIcon: false, backgroundColor: filled ? .white : nil)
            CircleSocialButton(icon: "apple.logo", isSystemIcon: true, backgroundColor: filled ? .white : nil, iconColor: .black)
        }
    }
}
