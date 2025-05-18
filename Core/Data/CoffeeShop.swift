//
//  CoffeeShop.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Core/Data/CoffeeShop.swift

import Foundation
import CoreLocation // We'll need this for coordinates

// Enum to represent the supported coffee shop brands
enum CoffeeBrand: String, CaseIterable, Identifiable, Codable {
    case starbucks = "Starbucks"
    case dutchBros = "Dutch Bros"
    case dunkin = "Dunkin'"

    var id: String { self.rawValue } // For Identifiable conformance
}

// Struct to represent a coffee shop
struct CoffeeShop: Identifiable, Codable {
    let id: UUID // Unique identifier for each coffee shop
    let name: String
    let brand: CoffeeBrand
    let latitude: Double
    let longitude: Double
    var address: String? // Optional address details

    // Computed property for CLLocationCoordinate2D, useful for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // Example initializer
    init(id: UUID = UUID(), name: String, brand: CoffeeBrand, latitude: Double, longitude: Double, address: String? = nil) {
        self.id = id
        self.name = name
        self.brand = brand
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

// Sample Data (We'll move this to CoffeeShopProvider later)
// For now, you can include it here to test, or wait until we create CoffeeShopProvider.swift
extension CoffeeShop {
    static let sampleShops: [CoffeeShop] = [
        CoffeeShop(name: "Starbucks - Main St", brand: .starbucks, latitude: 34.052235, longitude: -118.243683, address: "123 Main St, Los Angeles, CA"),
        CoffeeShop(name: "Dutch Bros - Downtown", brand: .dutchBros, latitude: 34.053235, longitude: -118.244683, address: "456 Central Ave, Los Angeles, CA"),
        CoffeeShop(name: "Dunkin' - City Center", brand: .dunkin, latitude: 34.054235, longitude: -118.245683, address: "789 Broadway, Los Angeles, CA"),
        CoffeeShop(name: "Starbucks - Riverwalk", brand: .starbucks, latitude: 33.448376, longitude: -112.074036, address: "101 River Rd, Phoenix, AZ"),
        CoffeeShop(name: "Dutch Bros - Northside", brand: .dutchBros, latitude: 33.684566, longitude: -117.826508, address: "202 North St, Irvine, CA")
    ]
}

