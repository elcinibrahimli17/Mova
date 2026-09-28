//
//  AppLanguage.swift
//  Mova
//
//  Created by Elchın on 16.09.26.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case azerbaijani = "az"
    case english = "en"
    case russian = "ru"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .azerbaijani: return "Azərbaycan"
        case .english: return "English"
        case .russian: return "Русский"
        }
    }
    
    var locale: Locale {
        Locale(identifier: rawValue)
        
    }
}
