import SwiftUI
import CoreData

struct ProductListAdminView: View {
    @StateObject private var viewModel = ProductListAdminViewModel()
    @State private var showAddProduct = false
    @State private var selectedProduct: NSManagedObject?
    @State private var showEditProduct = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.products, id: \.self) { product in
                ProductRowAdmin(product: product)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedProduct = product
                        showEditProduct = true
                    }
            }
            .onDelete { indexSet in
                viewModel.deleteProducts(at: indexSet)
            }
        }
        .navigationTitle("Ürün Yönetimi")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddProduct = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddProduct) {
            AdminPanelView {
                viewModel.loadProducts()
            }
        }
        .sheet(isPresented: $showEditProduct) {
            if let product = selectedProduct {
                AdminPanelView(editingProduct: product) {
                    viewModel.loadProducts()
                }
            }
        }
        .onAppear {
            viewModel.loadProducts()
        }
        .refreshable {
            viewModel.loadProducts()
        }
    }
}

struct ProductRowAdmin: View {
    let product: NSManagedObject
    
    var body: some View {
        HStack {
            if let imageData = product.value(forKey: "imageData") as? Data,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(product.value(forKey: "name") as? String ?? "")
                    .font(.headline)
                Text(product.value(forKey: "category") as? String ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let price = product.value(forKey: "price") as? Double {
                Text(String(format: "%.2f ₺", price))
                    .font(.subheadline.bold())
            }
        }
    }
} 