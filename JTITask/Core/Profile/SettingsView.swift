import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                List {
                    // Görünüm Ayarları
                    Section("Görünüm") {
                        Toggle(isOn: $isDarkMode) {
                            Label {
                                Text("Karanlık Mod")
                            } icon: {
                                Image(systemName: "moon.fill")
                            }
                        }
                    }
                    
                    // Dil Ayarları
                    Section(localizationManager.strings.languageSelection) {
                        ForEach([
                            (flag: "🇹🇷", name: "Türkçe", language: Language.turkish),
                            (flag: "🇬🇧", name: "English", language: Language.english),
                            (flag: "🇸🇪", name: "Svenska", language: Language.swedish)
                        ], id: \.language) { item in
                            Button {
                                withAnimation {
                                    localizationManager.currentLanguage = item.language
                                }
                            } label: {
                                HStack {
                                    Text("\(item.flag) \(item.name)")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if localizationManager.currentLanguage == item.language {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Bildirim Ayarları
                    Section("Bildirimler") {
                        Toggle("Kampanya Bildirimleri", isOn: .constant(true))
                        Toggle("Stok Bildirimleri", isOn: .constant(true))
                    }
                    
                    // Uygulama Bilgileri
                    Section("Uygulama Hakkında") {
                        HStack {
                            Text("Versiyon")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Gizlilik Politikası") {
                            // Gizlilik politikası sayfasına yönlendir
                        }
                        
                        Button("Kullanım Koşulları") {
                            // Kullanım koşulları sayfasına yönlendir
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Ayarlar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
} 