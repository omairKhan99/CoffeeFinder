//
//  CoffeeShop.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Core/Data/CoffeeShop.swift

import Foundation
import CoreLocation
import SwiftUI // Added for Color and Image

enum CoffeeBrand: String, CaseIterable, Identifiable, Codable, Equatable {
    case starbucks = "Starbucks"
    case dutchBros = "Dutch Bros"
    case dunkin = "Dunkin'"

    var id: String { self.rawValue }

    var markerColor: Color {
        switch self {
        case .starbucks:
            return Color(red: 0.0, green: 0.4, blue: 0.2)
        case .dutchBros:
            return Color.blue
        case .dunkin:
            return Color.orange
        }
    }

    var sfSymbolName: String {
        switch self {
        case .starbucks:
            return "cup.and.saucer.fill"
        case .dutchBros:
            return "wind"
        case .dunkin:
            return "mug.fill"
        }
    }
}

struct CoffeeShop: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let brand: CoffeeBrand
    let latitude: Double
    let longitude: Double
    var address: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(id: UUID = UUID(), name: String, brand: CoffeeBrand, latitude: Double, longitude: Double, address: String? = nil) {
        self.id = id
        self.name = name
        self.brand = brand
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

// Definition for ShopAnnotationItem, used by map views
struct ShopAnnotationItem: Identifiable {
    let id: UUID             // To conform to Identifiable for Map
    let name: String           // Shop name, potentially for tap actions
    let coordinate: CLLocationCoordinate2D
    let brand: CoffeeBrand     // To use for styling the marker

    // Initialize from a CoffeeShop
    init(shop: CoffeeShop) {
        self.id = shop.id
        self.name = shop.name
        self.coordinate = shop.coordinate
        self.brand = shop.brand
    }
}


extension CoffeeShop {
    static let sampleShops: [CoffeeShop] = [
        CoffeeShop(name: "Starbucks - Main St", brand: .starbucks, latitude: 34.052235, longitude: -118.243683, address: "123 Main St, Los Angeles, CA"),
        CoffeeShop(name: "Dutch Bros - Downtown", brand: .dutchBros, latitude: 34.053235, longitude: -118.244683, address: "456 Central Ave, Los Angeles, CA"),
        CoffeeShop(name: "Dunkin' - City Center", brand: .dunkin, latitude: 34.054235, longitude: -118.245683, address: "789 Broadway, Los Angeles, CA"),
        CoffeeShop(name: "Starbucks - Riverwalk", brand: .starbucks, latitude: 33.448376, longitude: -112.074036, address: "101 River Rd, Phoenix, AZ"),
        CoffeeShop(name: "Dutch Bros - Northside", brand: .dutchBros, latitude: 33.684566, longitude: -117.826508, address: "202 North St, Irvine, CA")
    ]
}
