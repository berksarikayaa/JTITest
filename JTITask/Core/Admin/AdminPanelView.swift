import SwiftUI
import PhotosUI
import CoreData
import AVFoundation

struct AdminPanelView: View {
    @StateObject private var viewModel: AdminPanelViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showImageSource = false
    @State private var showCameraPermissionAlert = false
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
                        .textInputAutocapitalization(.words)
                    
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
                    if let image = viewModel.selectedImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Button {
                        showImageSource = true
                    } label: {
                        Label("Görsel Ekle", systemImage: "photo")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.saveProduct()
                    }) {
                        Text(viewModel.isEditing ? "Güncelle" : "Kaydet")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Ürünü Düzenle" : "Yeni Ürün")
            .confirmationDialog("Görsel Seç", isPresented: $showImageSource) {
                Button("Fotoğraf Çek") {
                    checkCameraPermission()
                }
                
                Button("Galeriden Seç") {
                    showImagePicker = true
                }
                
                Button("İptal", role: .cancel) {}
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.selectedUIImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $viewModel.selectedUIImage, sourceType: .camera)
            }
            .alert("Kamera İzni Gerekli", isPresented: $showCameraPermissionAlert) {
                Button("Ayarlara Git") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("İptal", role: .cancel) {}
            } message: {
                Text("Kamerayı kullanabilmek için izin vermeniz gerekiyor.")
            }
            .alert("Başarılı", isPresented: $viewModel.showSuccessAlert) {
                Button("Tamam") {
                    onSave?()
                    dismiss()
                }
            } message: {
                Text(viewModel.isEditing ? "Ürün güncellendi." : "Ürün eklendi.")
            }
            .alert("Hata", isPresented: $viewModel.showError) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        showCamera = true
                    }
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert = true
        @unknown default:
            break
        }
    }
} 