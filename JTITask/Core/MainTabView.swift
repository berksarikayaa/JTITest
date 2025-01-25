import SwiftUI

struct MainView: View {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(localizationManager.strings.home)
                }
                .tag(0)
            
            ProductListView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text(localizationManager.strings.products)
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favoriler")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(localizationManager.strings.profile)
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Ayarlar")
                }
                .tag(4)
        }
        .environmentObject(cartManager)
        .environmentObject(localizationManager)
    }
}

struct MenuContent: View {
    @Binding var showMenu: Bool
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var safeAreaInsets: Double {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return Double(window.safeAreaInsets.top)
        }
        return 47
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear
                .frame(height: safeAreaInsets)
            
            HStack {
                Text("Menü")
                    .font(.title2.bold())
                
                Spacer()
                
                Button {
                    withAnimation(.spring()) {
                        showMenu = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Button {
                        selectedTab = 1
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    } label: {
                        MenuRow(title: localizationManager.strings.profile, icon: "person.circle.fill")
                    }
                    
                    Button {
                        selectedTab = 0
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    } label: {
                        MenuRow(title: localizationManager.strings.home, icon: "house.fill")
                    }
                    
                    Button {
                        selectedTab = 2
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    } label: {
                        MenuRow(title: localizationManager.strings.products, icon: "bag.fill")
                    }
                    
                    Button {
                        selectedTab = 3
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    } label: {
                        MenuRow(title: localizationManager.strings.cart, icon: "cart.fill")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .padding(.vertical, 10)
                
                // Dil seçimi bölümü
                VStack(alignment: .leading, spacing: 15) {
                    Text(localizationManager.strings.languageSelection)
                        .font(.headline)
                    
                    ForEach([
                        (flag: "🇹🇷", name: "Türkçe", language: Language.turkish),
                        (flag: "🇬🇧", name: "English", language: Language.english),
                        (flag: "🇸🇪", name: "Svenska", language: Language.swedish)
                    ], id: \.language) { item in
                        Button {
                            withAnimation {
                                localizationManager.currentLanguage = item.language
                                showMenu = false
                            }
                        } label: {
                            HStack {
                                Text("\(item.flag) \(item.name)")
                                    .font(.body)
                                Spacer()
                                if localizationManager.currentLanguage == item.language {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct MenuRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 24, height: 24)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.body)
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
} 