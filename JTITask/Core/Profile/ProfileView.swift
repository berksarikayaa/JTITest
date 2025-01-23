import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showAddProduct = false
    @State private var showLoginError = false
    
    var body: some View {
        NavigationView {
            if authManager.isAuthenticated {
                List {
                    if authManager.isAdmin {
                        Section("Admin Paneli") {
                            NavigationLink {
                                ProductListAdminView()
                            } label: {
                                Label("Ürün Yönetimi", systemImage: "cube.box")
                            }
                        }
                    }
                    
                    Section {
                        ProfileInfoRow(title: "E-posta", value: authManager.currentUser?.email ?? "")
                    }
                    
                    Section {
                        Button("Çıkış Yap") {
                            authManager.logout()
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Profilim")
            } else {
                VStack(spacing: 20) {
                    TextField("E-posta", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Şifre", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Giriş Yap") {
                        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if authManager.login(email: trimmedEmail, password: trimmedPassword) {
                            email = ""
                            password = ""
                        } else {
                            showLoginError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle("Giriş Yap")
                .alert("Hata", isPresented: $showLoginError) {
                    Button("Tamam", role: .cancel) { }
                } message: {
                    Text("E-posta veya şifre hatalı.")
                }
            }
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
} 