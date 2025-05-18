
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Core/Data/CoffeeShopProvider.swift

import Foundation
import CoreLocation // For CLLocationDistance

class CoffeeShopProvider: ObservableObject {
    @Published var shops: [CoffeeShop] = []

    init() {
        // Load initial sample shops
        // In a real app, this could fetch from an API or local database
        self.shops = CoffeeShop.sampleShops
    }

    // Example function to filter shops by brand (we can add more filters later)
    func getShops(filteredBy brands: [CoffeeBrand]? = nil, near location: CLLocation? = nil, within distance: CLLocationDistance? = nil) -> [CoffeeShop] {
        var filteredShops = shops

        if let brands = brands, !brands.isEmpty {
            filteredShops = filteredShops.filter { brands.contains($0.brand) }
        }

        if let userLocation = location, let maxDistance = distance {
            filteredShops = filteredShops.filter { shop in
                let shopLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
                return userLocation.distance(from: shopLocation) <= maxDistance
            }
        }
        
        // Optionally sort by distance if location is provided
        if let userLocation = location {
            filteredShops.sort {
                let loc1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let loc2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                return userLocation.distance(from: loc1) < userLocation.distance(from: loc2)
            }
        }

        return filteredShops
    }

    // Function to add a new shop (example, might not be used if data is static/remote)
    func addShop(_ shop: CoffeeShop) {
        shops.append(shop)
    }
}

