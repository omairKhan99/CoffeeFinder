//
//  CoffeeShopDetailView.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//

// CoffeeFinder/Features/CoffeeShopDetailView/CoffeeShopDetailView.swift

import SwiftUI
import MapKit // For MKCoordinateRegion if we add a mini-map later

struct CoffeeShopDetailView: View {
    let shop: CoffeeShop

    // State for a potential mini-map region
    @State private var region: MKCoordinateRegion

    init(shop: CoffeeShop) {
        self.shop = shop
        self._region = State(initialValue: MKCoordinateRegion(
            center: shop.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoomed-in span
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with Shop Name and Brand
                VStack(alignment: .center) {
                    Image(systemName: shop.brand.sfSymbolName)
                        .font(.system(size: 50))
                        .foregroundColor(shop.brand.markerColor)
                        .padding(.bottom, 5)
                    Text(shop.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text(shop.brand.rawValue)
                        .font(.title2)
                        .foregroundColor(shop.brand.markerColor)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)

                // Mini-Map
                Map(coordinateRegion: $region,
                    interactionModes: [], // No interaction for mini-map
                    annotationItems: [ShopAnnotationItem(shop: shop)]) { item in
                    MapMarker(coordinate: item.coordinate, tint: item.brand.markerColor)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)


                // Address
                if let address = shop.address, !address.isEmpty {
                    GroupBox(label: Label("Address", systemImage: "mappin.and.ellipse")) {
                        Text(address)
                            .font(.body)
                            .padding(.top, 2)
                        Button("Get Directions") {
                            openDirections()
                        }
                        .padding(.top, 5)
                        .buttonStyle(.borderedProminent)
                        .tint(shop.brand.markerColor)
                    }
                    .padding(.horizontal)
                }

                // Placeholder for other details
                GroupBox(label: Label("Details", systemImage: "info.circle")) {
                    Text("More shop details coming soon (e.g., hours, amenities, user ratings).")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle(shop.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Function to open directions in Apple Maps
    private func openDirections() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: shop.coordinate))
        mapItem.name = shop.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// Preview
struct CoffeeShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap in NavigationView for previewing navigation bar
            CoffeeShopDetailView(shop: CoffeeShop.sampleShops.first!)
        }
    }
}

