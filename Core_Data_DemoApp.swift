//
//  Core_Data_DemoApp.swift
//  Shared
//
//  Created by Leone on 1/9/22.
//

import SwiftUI

@main
struct Core_Data_DemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
