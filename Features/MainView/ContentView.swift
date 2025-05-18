//
//  ContentView.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//
// CoffeeFinder/Features/MainView/ContentView.swift

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var coffeeShopProvider = CoffeeShopProvider()

    @State private var selectedBrands: [CoffeeBrand] = CoffeeBrand.allCases
    @State private var selectedDistance: CLLocationDistance = 16093.4

    let distanceOptions: [String: CLLocationDistance] = [
        "1 mile": 1609.34,
        "3 miles": 4828.03,
        "5 miles": 8046.72,
        "10 miles": 16093.4,
        "20 miles": 32186.9
    ]
    var sortedDistanceKeys: [String] {
        distanceOptions.keys.sorted {
            distanceOptions[$0]! < distanceOptions[$1]!
        }
    }
    private var selectedDistanceKey: String {
        distanceOptions.first(where: { $0.value == selectedDistance })?.key ?? "10 miles"
    }

    var body: some View {
        NavigationView {
            VStack {
                if locationManager.authorizationStatus == .notDetermined {
                    InitialPermissionRequestView(locationManager: locationManager)
                } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                    LocationPermissionDeniedView()
                } else if locationManager.userLocation == nil && (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways) {
                    Text("Acquiring location...")
                        .padding()
                    ProgressView()
                } else {
                    FilterControlsView(
                        selectedBrands: $selectedBrands,
                        selectedDistanceKeyBinding: Binding(
                            get: { self.selectedDistanceKey },
                            set: { newKey in
                                self.selectedDistance = distanceOptions[newKey] ?? 16093.4
                            }
                        ),
                        distanceOptions: distanceOptions
                    )

                    List {
                        let shops = coffeeShopProvider.getShops(
                            filteredBy: selectedBrands,
                            near: locationManager.userLocation,
                            within: selectedDistance
                        )

                        if shops.isEmpty {
                            Text("No coffee shops found matching your criteria.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ForEach(shops) { shop in
                                CoffeeShopRow(shop: shop, userLocation: locationManager.userLocation)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("CoffeeFinder")
            .onAppear {
                if locationManager.authorizationStatus == .notDetermined {
                    locationManager.requestLocationPermission()
                } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
}

struct InitialPermissionRequestView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack {
            Image(systemName: "location.circle.fill")
                .resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80)
                .foregroundColor(.blue).padding()
            Text("Location Access Needed").font(.title2).padding(.bottom, 5)
            Text("To find coffee shops near you, please allow CoffeeFinder to access your location.")
                .multilineTextAlignment(.center).padding(.horizontal)
            Button("Allow Location Access") {
                locationManager.requestLocationPermission()
            }
            .padding().buttonStyle(.borderedProminent)
        }
    }
}

struct LocationPermissionDeniedView: View {
    var body: some View {
        VStack {
            Image(systemName: "location.slash.fill")
                .resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80)
                .foregroundColor(.red).padding()
            Text("Location Access Denied").font(.title2).padding(.bottom, 5)
            Text("CoffeeFinder cannot show nearby coffee shops without location access. Please enable location services for this app in Settings.")
                .multilineTextAlignment(.center).padding(.horizontal)
            if let url = URL(string: UIApplication.openSettingsURLString) {
                Button("Open Settings") { UIApplication.shared.open(url) }
                .padding().buttonStyle(.bordered)
            }
        }
    }
}

struct FilterControlsView: View {
    @Binding var selectedBrands: [CoffeeBrand]
    @Binding var selectedDistanceKeyBinding: String
    let distanceOptions: [String: CLLocationDistance]

    var sortedDistanceKeys: [String] {
        distanceOptions.keys.sorted { distanceOptions[$0]! < distanceOptions[$1]! }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Filter by Brand:").font(.headline).padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(CoffeeBrand.allCases) { brand in
                        Button(action: {
                            if selectedBrands.contains(brand) {
                                selectedBrands.removeAll { $0 == brand }
                            } else {
                                selectedBrands.append(brand)
                            }
                        }) {
                            Text(brand.rawValue)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(selectedBrands.contains(brand) ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(selectedBrands.contains(brand) ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }

            HStack {
                Text("Distance:").font(.headline)
                Picker("Distance", selection: $selectedDistanceKeyBinding) {
                    ForEach(sortedDistanceKeys, id: \.self) { key in
                        Text(key).tag(key)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
            .padding(.top, 5)
        }
        .padding(.vertical, 10)
    }
}

struct CoffeeShopRow: View {
    let shop: CoffeeShop
    var userLocation: CLLocation?

    private func distanceString(from userLocation: CLLocation?, to shopLocation: CLLocation) -> String {
        guard let userLocation = userLocation else { return "" }
        let distanceInMeters = userLocation.distance(from: shopLocation)
        let distanceInMiles = distanceInMeters / 1609.34
        return String(format: "%.2f mi", distanceInMiles)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(shop.name).font(.headline)
                Text(shop.brand.rawValue).font(.subheadline).foregroundColor(.secondary)
                if let address = shop.address, !address.isEmpty {
                    Text(address).font(.caption).foregroundColor(.gray)
                }
            }
            Spacer()
            if let location = userLocation {
                let shopCLLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
                Text(distanceString(from: location, to: shopCLLocation))
                    .font(.subheadline).foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
