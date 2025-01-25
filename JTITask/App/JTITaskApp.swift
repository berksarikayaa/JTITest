import SwiftUI
import CoreData

@main
struct JTITaskApp: App {
    let persistenceController = CoreDataManager.shared
    @StateObject private var cartManager = CartManager()
    @StateObject private var localizationManager = LocalizationManager()
    
    init() {
        // Örnek ürünleri ekle
        persistenceController.seedProducts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .environmentObject(cartManager)
                .environmentObject(localizationManager)
        }
    }
} 
