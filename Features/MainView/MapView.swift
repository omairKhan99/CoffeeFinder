//
//  MapView.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Features/MainView/MapView.swift

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var shops: [CoffeeShop]
    @Binding var userLocation: CLLocation? // To center the map

    // State for the map region
    @State private var region: MKCoordinateRegion

    // State to hold annotation items
    @State private var annotationItems: [ShopAnnotationItem] = []

    // Initializer to set up the initial region
    init(shops: Binding<[CoffeeShop]>, userLocation: Binding<CLLocation?>) {
        self._shops = shops
        self._userLocation = userLocation

        let initialCenter: CLLocationCoordinate2D
        if let loc = userLocation.wrappedValue {
            initialCenter = loc.coordinate
        } else if let firstShop = shops.wrappedValue.first {
            initialCenter = firstShop.coordinate
        } else {
            // Default to a generic location if no user location or shops
            initialCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        }
        self._region = State(initialValue: MKCoordinateRegion(
            center: initialCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.none), // We manage region manually for now
            annotationItems: annotationItems) { item in
            MapMarker(coordinate: item.coordinate, tint: item.brand.markerColor)
        }
        .onAppear {
            updateRegionAndAnnotations()
        }
        .onChange(of: shops) { _ in // Swift 5.5+ syntax for onChange
            updateRegionAndAnnotations()
        }
        .onChange(of: userLocation) { _ in
            updateRegionAndAnnotations(centerOnUser: true)
        }
    }

    private func updateRegionAndAnnotations(centerOnUser: Bool = false) {
        if centerOnUser, let loc = userLocation {
            region.center = loc.coordinate
        } else if region.center.latitude == 0 && region.center.longitude == 0, let loc = userLocation {
             // If region was default and user location becomes available
            region.center = loc.coordinate
        } else if shops.isEmpty, let loc = userLocation {
            region.center = loc.coordinate // Center on user if no shops
        }


        // Convert CoffeeShop to ShopAnnotationItem
        self.annotationItems = shops.map { ShopAnnotationItem(shop: $0) }
    }
}

// Identifiable wrapper for CoffeeShop to be used in Map annotations
struct ShopAnnotationItem: Identifiable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    let brand: CoffeeBrand

    init(shop: CoffeeShop) {
        self.id = shop.id
        self.name = shop.name
        self.coordinate = shop.coordinate
        self.brand = shop.brand
    }
}

// Helper to get a distinct color for each brand on the map
extension CoffeeBrand {
    var markerColor: Color {
        switch self {
        case .starbucks:
            return .green
        case .dutchBros:
            return .blue
        case .dunkin:
            return .orange
        }
    }
}

