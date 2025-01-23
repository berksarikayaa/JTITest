import Foundation

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var currentUser: Admin?
    
    private let adminCredentials = Admin(
        id: "admin123",
        email: "admin@jti.com",
        password: "Admin123!",
        isAdmin: true
    )
    
    func login(email: String, password: String) -> Bool {
        print("Giriş denemesi - Email: \(email), Password: \(password)") // Debug için
        print("Admin bilgileri - Email: \(adminCredentials.email), Password: \(adminCredentials.password)") // Debug için
        
        if email.lowercased() == adminCredentials.email.lowercased() && 
           password == adminCredentials.password {
            isAuthenticated = true
            isAdmin = true
            currentUser = adminCredentials
            print("Giriş başarılı!") // Debug için
            return true
        }
        print("Giriş başarısız!") // Debug için
        return false
    }
    
    func logout() {
        isAuthenticated = false
        isAdmin = false
        currentUser = nil
    }
} 