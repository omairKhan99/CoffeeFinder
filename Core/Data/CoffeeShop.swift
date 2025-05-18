//
//  CoffeeShop.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Core/Data/CoffeeShop.swift

// CoffeeFinder/Core/Data/CoffeeShop.swift

import Foundation
import CoreLocation

enum CoffeeBrand: String, CaseIterable, Identifiable, Codable, Equatable { // Added Equatable
    case starbucks = "Starbucks"
    case dutchBros = "Dutch Bros"
    case dunkin = "Dunkin'"

    var id: String { self.rawValue }
}

struct CoffeeShop: Identifiable, Codable, Equatable { // Added Equatable
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

    // Equatable conformance can be synthesized by the compiler
    // because all its stored properties (UUID, String, CoffeeBrand, Double, Optional<String>)
    // are Equatable.
    // static func == (lhs: CoffeeShop, rhs: CoffeeShop) -> Bool {
    //     return lhs.id == rhs.id &&
    //            lhs.name == rhs.name &&
    //            lhs.brand == rhs.brand &&
    //            lhs.latitude == rhs.latitude &&
    //            lhs.longitude == rhs.longitude &&
    //            lhs.address == rhs.address
    // }
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


