import SwiftUI

struct MainView: View {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showMenu = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                Color(colorScheme == .dark ? .black : .white)
                    .ignoresSafeArea()
                
                // Ana içerik
                HomeView()
                    .navigationTitle(showMenu ? "" : localizationManager.strings.home)
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
                    MenuContent(showMenu: $showMenu)
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
}

struct MenuContent: View {
    @Binding var showMenu: Bool
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status bar için boşluk
            Color.clear
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
            
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
                    MenuLink(title: localizationManager.strings.profile, icon: "person.circle.fill", destination: AnyView(ProfileView()), showMenu: $showMenu)
                    MenuLink(title: localizationManager.strings.home, icon: "house.fill", destination: AnyView(HomeView()), showMenu: $showMenu)
                    MenuLink(title: localizationManager.strings.products, icon: "bag.fill", destination: AnyView(ProductListView()), showMenu: $showMenu)
                    MenuLink(title: localizationManager.strings.cart, icon: "cart.fill", destination: AnyView(CartView()), showMenu: $showMenu)
                }
                .frame(height: 44)
                
                Divider()
                    .padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(localizationManager.strings.languageSelection)
                        .font(.headline)
                    
                    Group {
                        LanguageButton(title: "Türkçe", flag: "🇹🇷", 
                            isSelected: localizationManager.currentLanguage == .turkish) {
                            localizationManager.currentLanguage = .turkish
                        }
                        
                        LanguageButton(title: "English", flag: "🇬🇧", 
                            isSelected: localizationManager.currentLanguage == .english) {
                            localizationManager.currentLanguage = .english
                        }
                        
                        LanguageButton(title: "Svenska", flag: "🇸🇪", 
                            isSelected: localizationManager.currentLanguage == .swedish) {
                            localizationManager.currentLanguage = .swedish
                        }
                    }
                    .frame(height: 44)
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

struct MenuLink: View {
    let title: String
    let icon: String
    let destination: AnyView
    @Binding var showMenu: Bool
    
    var body: some View {
        NavigationLink {
            destination
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CartButton()
                    }
                }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 24, height: 24) // Sabit boyut
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.body)
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            withAnimation(.spring()) {
                showMenu = false
            }
        })
    }
}

struct LanguageButton: View {
    let title: String
    let flag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(flag)
                    .font(.title2)
                    .frame(width: 24, height: 24) // Sabit boyut
                
                Text(title)
                    .font(.body)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
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