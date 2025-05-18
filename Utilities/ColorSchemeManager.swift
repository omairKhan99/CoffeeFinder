//
//  ColorSchemeManager.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Utilities/ColorSchemeManager.swift

import SwiftUI

// Enum to define the available color schemes
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { self.rawValue }

    // Returns the SwiftUI ColorScheme equivalent
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil // nil tells SwiftUI to use the system's setting
        }
    }
}

// ObservableObject to manage the app's appearance setting
class AppearanceManager: ObservableObject {
    // @AppStorage will persist the user's choice
    @AppStorage("appearanceMode") var currentAppearance: AppearanceMode = .system {
        didSet {
            // This will trigger UI updates when the appearance changes
            objectWillChange.send()
        }
    }
}

