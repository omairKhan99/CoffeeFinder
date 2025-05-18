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
    @Binding var userLocation: CLLocation?
    @Binding var selectedShopForDetail: CoffeeShop?

    // State for the map's camera position
    @State private var mapCameraPosition: MapCameraPosition

    // Initializer to set up the initial camera position
    init(shops: Binding<[CoffeeShop]>, userLocation: Binding<CLLocation?>, selectedShopForDetail: Binding<CoffeeShop?>) {
        self._shops = shops
        self._userLocation = userLocation
        self._selectedShopForDetail = selectedShopForDetail

        let initialCenter: CLLocationCoordinate2D
        if let loc = userLocation.wrappedValue {
            initialCenter = loc.coordinate
        } else if let firstShop = shops.wrappedValue.first {
            initialCenter = firstShop.coordinate
        } else {
            // Corrected typo: CLLocationCoordinate2D
            initialCenter = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        }
        // Initialize camera position
        self._mapCameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: initialCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )))
    }

    var body: some View {
        // iOS 17+ Map syntax
        Map(position: $mapCameraPosition) {
            // User Annotation (shows the blue dot for user location)
            UserAnnotation()

            // Coffee Shop Annotations
            ForEach(shops) { shop in
                Annotation(shop.name, coordinate: shop.coordinate) {
                    Button(action: {
                        self.selectedShopForDetail = shop
                    }) {
                        VStack(spacing: 2) {
                            Image(systemName: shop.brand.sfSymbolName)
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(shop.brand.markerColor)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            Text(shop.brand.rawValue.prefix(1))
                                .font(.caption)
                                .bold()
                                .foregroundColor(shop.brand.markerColor)
                        }
                    }
                }
                .annotationTitles(.hidden) // Hides default title/subtitle callout if not needed
            }
        }
        .mapControls {
             MapUserLocationButton() // Adds a button to center on user location
             MapCompass()
             MapScaleView()
        }
        .onAppear {
            updateCameraPosition()
        }
        .onChange(of: shops) { oldValue, newValue in // Updated onChange
            updateCameraPosition()
        }
        .onChange(of: userLocation) { oldValue, newValue in // Updated onChange
            updateCameraPosition(centerOnUser: true)
        }
    }

    private func updateCameraPosition(centerOnUser: Bool = false) {
        let currentRegion = mapCameraPosition.region ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default SF
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        var newCenter = currentRegion.center
        let newSpan = currentRegion.span // Changed to let, as it's not mutated here

        if centerOnUser, let loc = userLocation {
            newCenter = loc.coordinate
        } else if (currentRegion.center.latitude == 37.7749 && currentRegion.center.longitude == -122.4194), let loc = userLocation {
            newCenter = loc.coordinate
        } else if !shops.isEmpty && userLocation == nil {
            if let firstShop = shops.first { newCenter = firstShop.coordinate }
        } else if shops.isEmpty, let loc = userLocation {
            newCenter = loc.coordinate
        }

        let updatedRegion = MKCoordinateRegion(center: newCenter, span: newSpan)
        
        // Check if the region actually needs to change to avoid unnecessary updates
        if !areRegionsEqual(currentRegion, updatedRegion) {
            withAnimation {
                mapCameraPosition = .region(updatedRegion)
            }
        }
    }
    
    // Helper function to compare MKCoordinateRegions
    private func areRegionsEqual(_ region1: MKCoordinateRegion, _ region2: MKCoordinateRegion) -> Bool {
        return region1.center.latitude == region2.center.latitude &&
               region1.center.longitude == region2.center.longitude &&
               region1.span.latitudeDelta == region2.span.latitudeDelta &&
               region1.span.longitudeDelta == region2.span.longitudeDelta
    }
}

