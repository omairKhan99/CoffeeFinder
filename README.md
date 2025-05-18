# Coffee Finder ☕️📍

**Find your favorite coffee shops (Starbucks, Dutch Bros, Dunkin') quickly and easily!**

## Overview

Coffee Finder is an iOS application designed to help users locate nearby Starbucks, Dutch Bros, and Dunkin' coffee shops. Inspired by the convenience of apps like OctaneBuddy, Coffee Finder aims to provide a clean, intuitive interface for discovering your next caffeine fix, complete with distance filtering, map views, and personalized preferences.

This project is currently under active development using Swift and SwiftUI.

## ✨ Features Implemented

Here's a rundown of the features currently available in Coffee Finder:

### 🗺️ Core Functionality & Mapping
* **Shop Discovery:** Displays a curated list of Starbucks, Dutch Bros, and Dunkin' coffee shops. (Currently uses sample data for prototyping).
* **Interactive Map View:**
    * Shows coffee shop locations on an integrated map (powered by MapKit).
    * Displays the user's current location.
    * Custom map annotations for each brand, featuring unique SF Symbols and brand colors.
    * Tappable map annotations to view shop details.
* **Detailed Shop Information:**
    * Dedicated detail view for each coffee shop.
    * Displays shop name, brand, address (if available), and a mini-map focused on the shop's location.
    * "Get Directions" button that opens Apple Maps to navigate to the selected shop.
* **List View:** Alternative list display of nearby coffee shops, showing essential details and distance.

### 🔍 Filtering & Sorting
* **Brand Filtering:**
    * Filter shops by one or more brands (Starbucks, Dutch Bros, Dunkin').
    * Interactive brand selection buttons with visual feedback.
* **Distance Filtering:**
    * Filter shops based on their proximity to the user's current location.
    * Predefined distance options (e.g., 1 mile, 3 miles, 5 miles, 10 miles, 20 miles).
* **Dynamic Updates:** Map and list views update automatically based on selected filters.
* **Distance Display:** Clearly shows the calculated distance to each coffee shop from the user's location in the list and detail views.

### 🎨 User Interface & Experience
* **Clean & Modern UI:** Built with SwiftUI for a responsive and contemporary feel.
* **Navigation:** Smooth navigation between map/list, filter controls, and shop detail views.
* **Location Permission Handling:**
    * Gracefully requests location access when needed.
    * Provides clear guidance if location permissions are denied, with a shortcut to app settings.
    * Indicates when the app is acquiring the user's location.
* **Dark Mode Support:**
    * Full support for Light and Dark system appearances.
    * Manual appearance toggle (System, Light, Dark) accessible from the navigation bar.
    * User's appearance preference is saved and reapplied on subsequent app launches.
* **App Display Name:** Configured as "Coffee Finder" (with a space) for a polished home screen presence.

### 🛠️ Technical Foundation
* **Language:** Swift
* **UI Framework:** SwiftUI
* **Location Services:** CoreLocation for fetching user's location.
* **Mapping:** MapKit for displaying maps and annotations.
* **Data Management:**
    * ObservableObjects for managing state (location, coffee shop data, appearance).
    * `@AppStorage` for persisting user preferences (like appearance mode).
    * Structured data models for coffee shops and brands.
* **Project Organization:** Clear and maintainable file and folder structure.

###<img width="393" alt="image" src="https://github.com/user-attachments/assets/1897ae82-1b69-4cc0-ac35-edfa441cf045" /> 

###<img width="405" alt="image" src="https://github.com/user-attachments/assets/98647e7e-31ae-4392-91c2-499c4571dba3" />






## 🚀 Future Enhancements (Planned)

While the core experience is taking shape, here are some features planned for future iterations:

* **Settings Screen:**
    * **Favorite Coffee Shops:** Ability to mark shops as favorites and view them in a dedicated list.
    * **Default Navigation App:** Preference for choosing between Apple Maps, Google Maps, or Waze for directions.
* **Real-time Data:** Integration with a backend or third-party API (e.g., Google Places) to fetch real-time coffee shop data instead of relying on sample data.
* **CarPlay Integration:** Extend functionality for use in vehicles equipped with CarPlay.
* **Enhanced UI/UX:**
    * Using actual brand logos for map annotations and UI elements.
    * Further UI polish and animations.
* **Advanced Filtering/Sorting:** More options for sorting (e.g., by name) or filtering (e.g., open now).

## ⚙️ Getting Started (Development)

1.  Clone the repository.
2.  Open the `.xcodeproj` file in Xcode (ensure you have a compatible version for the targeted iOS SDK).
3.  Add necessary privacy descriptions to `Info.plist` (e.g., `NSLocationWhenInUseUsageDescription`).
4.  Build and run on a simulator or a physical device.

---

Thank you for checking out Coffee Finder!
