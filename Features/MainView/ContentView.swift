//
//  ContentView.swift
//  CoffeeFinder
//
//  Created by Omair Khan on 5/17/25.
//
// CoffeeFinder/Features/MainView/ContentView.swift

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var coffeeShopProvider = CoffeeShopProvider()
    @EnvironmentObject private var appearanceManager: AppearanceManager // Access the manager

    @State private var selectedBrands: [CoffeeBrand] = CoffeeBrand.allCases
    @State private var selectedDistance: CLLocationDistance = 16093.4 // Default to 10 miles

    @State private var selectedShopForDetail: CoffeeShop?
    @State private var showDetailViewSheet: Bool = false

    let distanceOptions: [String: CLLocationDistance] = [
        "1 mile": 1609.34, "3 miles": 4828.03, "5 miles": 8046.72,
        "10 miles": 16093.4, "20 miles": 32186.9
    ]
    var sortedDistanceKeys: [String] {
        distanceOptions.keys.sorted { distanceOptions[$0]! < distanceOptions[$1]! }
    }
    private var selectedDistanceKey: String {
        distanceOptions.first(where: { $0.value == selectedDistance })?.key ?? "10 miles"
    }

    private var filteredShops: [CoffeeShop] {
        coffeeShopProvider.getShops(
            filteredBy: selectedBrands,
            near: locationManager.userLocation,
            within: selectedDistance
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if locationManager.authorizationStatus == .notDetermined {
                    InitialPermissionRequestView(locationManager: locationManager)
                } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                    LocationPermissionDeniedView()
                } else if locationManager.userLocation == nil && (locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways) {
                    VStack { Text("Acquiring location...").padding(); ProgressView() }.frame(maxHeight: .infinity)
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

                    MapView(
                        shops: .constant(filteredShops),
                        userLocation: $locationManager.userLocation,
                        selectedShopForDetail: $selectedShopForDetail
                    )
                    .frame(height: UIScreen.main.bounds.height / 2.5)
                    .edgesIgnoringSafeArea(.horizontal)
                    .onChange(of: selectedShopForDetail) { oldValue, newValue in // Updated onChange
                        if newValue != nil {
                            showDetailViewSheet = true
                        }
                    }

                    List {
                        if filteredShops.isEmpty {
                            Text("No coffee shops found matching your criteria.")
                                .foregroundColor(.secondary).padding()
                        } else {
                            ForEach(filteredShops) { shop in
                                NavigationLink(destination: CoffeeShopDetailView(shop: shop)) {
                                    CoffeeShopRow(shop: shop, userLocation: locationManager.userLocation)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Coffee Finder") // Display name set in Info.plist
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Appearance", selection: $appearanceManager.currentAppearance) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                    } label: {
                        Image(systemName: iconForCurrentAppearance())
                    }
                }
            }
            .onAppear {
                if locationManager.authorizationStatus == .notDetermined {
                    locationManager.requestLocationPermission()
                } else if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    locationManager.startUpdatingLocation()
                }
            }
            .sheet(isPresented: $showDetailViewSheet) {
                if let shop = selectedShopForDetail {
                    NavigationView {
                         CoffeeShopDetailView(shop: shop)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Close") {
                                        showDetailViewSheet = false
                                        selectedShopForDetail = nil
                                    }
                                }
                            }
                            // Propagate appearance manager to the sheet content
                            .environmentObject(appearanceManager)
                            .preferredColorScheme(appearanceManager.currentAppearance.colorScheme)
                    }
                }
            }
        }
        // Apply the preferred color scheme to the NavigationView as well
        .preferredColorScheme(appearanceManager.currentAppearance.colorScheme)
    }

    // Helper function to get the appropriate icon for the appearance toggle
    private func iconForCurrentAppearance() -> String {
        switch appearanceManager.currentAppearance {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "circle.lefthalf.filled.righthalf.striped.horizontal"
        }
    }
}

// InitialPermissionRequestView, LocationPermissionDeniedView, FilterControlsView, CoffeeShopRow
// remain the same.

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
            Button("Allow Location Access") { locationManager.requestLocationPermission() }
            .padding().buttonStyle(.borderedProminent)
        }.frame(maxHeight: .infinity)
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
        }.frame(maxHeight: .infinity)
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
                            HStack {
                                Image(systemName: brand.sfSymbolName)
                                Text(brand.rawValue)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(selectedBrands.contains(brand) ? brand.markerColor : Color.secondary.opacity(0.2))
                            .foregroundColor(selectedBrands.contains(brand) ? .white : .primary)
                            .cornerRadius(8).shadow(radius: selectedBrands.contains(brand) ? 3 : 0)
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
                .padding(.trailing, 5)
                .tint(Color.blue)
            }
            .padding(.horizontal)
            .padding(.top, 5)
        }
        .padding(.vertical, 10)
        .background(Color(uiColor: .systemGray6).edgesIgnoringSafeArea(.horizontal))
    }
}

struct CoffeeShopRow: View {
    let shop: CoffeeShop
    var userLocation: CLLocation?

    private func distanceString(from userLocation: CLLocation?, to shopLocation: CLLocation) -> String {
        guard let userLocation = userLocation else { return "" }
        let distanceInMeters = userLocation.distance(from: shopLocation)
        let distanceInMiles = distanceInMeters / 1609.34
        return String(format: "%.1f mi", distanceInMiles)
    }

    var body: some View {
        HStack {
            Image(systemName: shop.brand.sfSymbolName)
                .foregroundColor(shop.brand.markerColor)
                .font(.title2)
                .frame(width: 30)

            VStack(alignment: .leading) {
                Text(shop.name).font(.headline)
                Text(shop.brand.rawValue).font(.subheadline).foregroundColor(shop.brand.markerColor.opacity(0.8))
                if let address = shop.address, !address.isEmpty {
                    Text(address).font(.caption).foregroundColor(.gray)
                }
            }
            Spacer()
            if userLocation != nil {
                let shopCLLocation = CLLocation(latitude: shop.latitude, longitude: shop.longitude)
                Text(distanceString(from: userLocation, to: shopCLLocation))
                    .font(.subheadline).foregroundColor(.blue)
            }
        }
        .padding(.vertical, 6)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppearanceManager()) // Add for preview
    }
}
