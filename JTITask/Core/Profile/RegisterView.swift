import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Kişisel Bilgiler") {
                    TextField("Ad Soyad", text: $fullName)
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    TextField("E-posta", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                Section("Güvenlik") {
                    SecureField("Şifre", text: $password)
                        .textContentType(.newPassword)
                    
                    SecureField("Şifre Tekrar", text: $confirmPassword)
                        .textContentType(.newPassword)
                }
                
                Section {
                    Button("Kayıt Ol") {
                        register()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Yeni Hesap Oluştur")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert("Hata", isPresented: $showError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func register() {
        // Form validasyonu
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Boş alan kontrolü
        if trimmedEmail.isEmpty || trimmedPassword.isEmpty || 
           trimmedConfirmPassword.isEmpty || trimmedFullName.isEmpty {
            errorMessage = "Lütfen tüm alanları doldurun."
            showError = true
            return
        }
        
        // E-posta formatı kontrolü
        if !isValidEmail(trimmedEmail) {
            errorMessage = "Lütfen geçerli bir e-posta adresi girin."
            showError = true
            return
        }
        
        // Şifre uzunluğu kontrolü
        if trimmedPassword.count < 6 {
            errorMessage = "Şifre en az 6 karakter olmalıdır."
            showError = true
            return
        }
        
        // Şifre eşleşme kontrolü
        if trimmedPassword != trimmedConfirmPassword {
            errorMessage = "Şifreler eşleşmiyor."
            showError = true
            return
        }
        
        // Kayıt işlemi
        if authManager.register(email: trimmedEmail, 
                              password: trimmedPassword, 
                              fullName: trimmedFullName) {
            dismiss()
        } else {
            errorMessage = "Bu e-posta adresi zaten kullanılıyor."
            showError = true
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
} 