import SwiftUI
import CoreData

@main
struct JTITaskApp: App {
    let persistenceController = CoreDataManager.shared
    @StateObject private var cartManager = CartManager()
    @StateObject private var localizationManager = LocalizationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cartManager)
                .environmentObject(localizationManager)
        }
    }
} 
