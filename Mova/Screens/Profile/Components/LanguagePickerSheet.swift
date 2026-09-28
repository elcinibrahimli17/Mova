//
//  LanguagePickerSheet.swift
//  Mova
//
//  Created by Elchın on 16.09.26.
//

import SwiftUI

struct LanguagePickerSheet: View {
    @Binding var selected: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(AppLanguage.allCases) { language in
            Button {
                selected = language.rawValue
                dismiss()
            } label: {
                HStack {
                    Text(language.displayName)
                        .foregroundColor(.black)
                    Spacer()
                    if selected == language.rawValue {
                        Image(systemName: "checkmark")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LanguagePickerSheet(selected: .constant("en"))
    }
}
