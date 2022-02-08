//
//  Brave_iOS_AppApp.swift
//  Brave-iOS-App
//
//

import SwiftUI

@main
struct Brave_iOS_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
