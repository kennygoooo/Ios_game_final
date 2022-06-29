//
//  Part_1App.swift
//  Part 1
//
//  
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct Part_1App: App {
    
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
