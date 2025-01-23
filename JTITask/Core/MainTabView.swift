import SwiftUI

struct MainView: View {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showMenu = false
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                Color(colorScheme == .dark ? .black : .white)
                    .ignoresSafeArea()
                
                // Ana içerik
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView()
                    case 1:
                        ProfileView()
                    case 2:
                        ProductListView()
                    case 3:
                        CartView()
                    default:
                        HomeView()
                    }
                }
                .navigationTitle(showMenu ? "" : getTitle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !showMenu {
                            Button {
                                withAnimation(.spring()) {
                                    showMenu.toggle()
                                }
                            } label: {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CartButton()
                    }
                }
                .offset(x: showMenu ? UIScreen.main.bounds.width * 0.6 : 0)
                .disabled(showMenu)
                
                // Karartma efekti
                if showMenu {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showMenu = false
                            }
                        }
                        .transition(.opacity)
                }
                
                // Hamburger Menü
                if showMenu {
                    MenuContent(showMenu: $showMenu, selectedTab: $selectedTab)
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                }
            }
            .background(Color(colorScheme == .dark ? .black : .white))
        }
        .environmentObject(cartManager)
        .environmentObject(localizationManager)
    }
    
    private func getTitle() -> String {
        switch selectedTab {
        case 0:
            return localizationManager.strings.home
        case 1:
            return localizationManager.strings.profile
        case 2:
            return localizationManager.strings.products
        case 3:
            return localizationManager.strings.cart
        default:
            return localizationManager.strings.home
        }
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

struct CartButton: View {
    @ObservedObject private var cartManager = CartManager.shared
    
    var body: some View {
        NavigationLink(destination: CartView()) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.title3)
                    .foregroundColor(.primary)
                
                if cartManager.itemCount > 0 {
                    Text("\(cartManager.itemCount)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
        }
    }
} 