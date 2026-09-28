//
//  AuthLogo.swift
//  Mova
//
//  Created by Elchın on 04.09.26.
//

import SwiftUI

struct AuthLogo: View {
    var body: some View {
        Text("M")
            .authLogoModifier()
    }
}

#Preview() {
    AuthLogo()
}
