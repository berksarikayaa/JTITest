import SwiftUI

struct ProductSpecsTable: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ürün Özellikleri")
                .font(.headline)
            
            VStack(spacing: 12) {
                SpecRow(title: "Kategori", value: product.category.rawValue)
                SpecRow(title: "Nikotin Oranı", value: product.nicotineStrength)
                SpecRow(title: "Paket İçeriği", value: "\(product.quantity) poşet")
                SpecRow(title: "Ürün Kodu", value: product.id)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SpecRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}
