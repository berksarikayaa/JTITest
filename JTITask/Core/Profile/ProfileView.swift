import SwiftUI

struct ProfileView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                List {
                    Section {
                        ProfileInfoRow(title: "Ad Soyad", value: "Kullanıcı Adı")
                        ProfileInfoRow(title: "E-posta", value: "kullanici@email.com")
                    }
                    
                    Section {
                        NavigationLink("Siparişlerim") {
                            Text("Siparişler")
                        }
                        NavigationLink("Adreslerim") {
                            Text("Adresler")
                        }
                        NavigationLink("Ayarlar") {
                            Text("Ayarlar")
                        }
                    }
                    
                    Section {
                        Button("Çıkış Yap") {
                            isLoggedIn = false
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Profilim")
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
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

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Giriş Yap") {
                isLoggedIn = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Giriş Yap")
    }
} 