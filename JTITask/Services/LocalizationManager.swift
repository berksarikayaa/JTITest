import Foundation

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            updateLocalizedStrings()
        }
    }
    
    @Published var strings: LocalizedStrings = .turkish
    
    var currencySymbol: String {
        switch currentLanguage {
        case .turkish: return "₺"
        case .english: return "$"
        case .swedish: return "€"
        }
    }
    
    var currencyRate: Double {
        switch currentLanguage {
        case .turkish: return 1.0
        case .english: return 0.035 // 1 TL = 0.035 USD
        case .swedish: return 0.032 // 1 TL = 0.032 EUR
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        let convertedPrice = price * currencyRate
        return "\(currencySymbol)\(String(format: "%.2f", convertedPrice))"
    }
    
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "tr"
        currentLanguage = Language(rawValue: savedLanguage) ?? .turkish
        updateLocalizedStrings()
    }
    
    private func updateLocalizedStrings() {
        switch currentLanguage {
        case .turkish:
            strings = .turkish
        case .english:
            strings = .english
        case .swedish:
            strings = .swedish
        }
    }
}

enum Language: String {
    case turkish = "tr"
    case english = "en"
    case swedish = "sv"
}

struct LocalizedStrings {
    var menu: String
    var profile: String
    var home: String
    var products: String
    var cart: String
    var languageSelection: String
    var checkout: String
    var emptyCart: String
    var startShopping: String
    var total: String
    var addToCart: String
    var quantity: String
    
    static let turkish = LocalizedStrings(
        menu: "Menü",
        profile: "Profil",
        home: "Ana Sayfa",
        products: "Ürünler",
        cart: "Sepet",
        languageSelection: "Dil Seçimi",
        checkout: "Ödemeye Geç",
        emptyCart: "Sepetiniz boş",
        startShopping: "Ürün eklemek için alışverişe başlayın",
        total: "Toplam",
        addToCart: "Sepete Ekle",
        quantity: "Adet"
    )
    
    static let english = LocalizedStrings(
        menu: "Menu",
        profile: "Profile",
        home: "Home",
        products: "Products",
        cart: "Cart",
        languageSelection: "Language Selection",
        checkout: "Checkout",
        emptyCart: "Your cart is empty",
        startShopping: "Start shopping to add products",
        total: "Total",
        addToCart: "Add to Cart",
        quantity: "Quantity"
    )
    
    static let swedish = LocalizedStrings(
        menu: "Meny",
        profile: "Profil",
        home: "Hem",
        products: "Produkter",
        cart: "Vagn",
        languageSelection: "Välj språk",
        checkout: "Till kassan",
        emptyCart: "Din vagn är tom",
        startShopping: "Börja handla för att lägga till produkter",
        total: "Totalt",
        addToCart: "Lägg i varukorgen",
        quantity: "Antal"
    )
} 