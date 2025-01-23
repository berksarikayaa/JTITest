import SwiftUI
import PhotosUI
import CoreData

struct AdminPanelView: View {
    @StateObject private var viewModel: AdminPanelViewModel
    @Environment(\.dismiss) private var dismiss
    var onSave: (() -> Void)?
    
    init(editingProduct: NSManagedObject? = nil, onSave: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: AdminPanelViewModel(editingProduct: editingProduct))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Ürün Bilgileri") {
                    TextField("Ürün Adı", text: $viewModel.productName)
                    
                    TextEditor(text: $viewModel.productDescription)
                        .frame(height: 100)
                    
                    TextField("Fiyat", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Nikotin Oranı", text: $viewModel.nicotineStrength)
                    
                    TextField("Adet", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                    
                    Picker("Kategori", selection: $viewModel.selectedCategory) {
                        ForEach(ProductCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section("Ürün Görseli") {
                    PhotosPicker(selection: $viewModel.selectedItem,
                               matching: .images) {
                        if let image = viewModel.selectedImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            HStack {
                                Image(systemName: "photo")
                                Text("Görsel Seç")
                            }
                        }
                    }
                    .onChange(of: viewModel.selectedItem) { oldValue, newValue in
                        viewModel.loadImage()
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.saveProduct()
                    }) {
                        Text("Ürünü Kaydet")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Ürünü Düzenle" : "Yeni Ürün Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
            .alert("Başarılı", isPresented: $viewModel.showSuccessAlert) {
                Button("Tamam") {
                    onSave?()
                    dismiss()
                }
            } message: {
                Text(viewModel.isEditing ? "Ürün başarıyla güncellendi." : "Ürün başarıyla eklendi.")
            }
            .alert("Hata", isPresented: $viewModel.showError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
} 