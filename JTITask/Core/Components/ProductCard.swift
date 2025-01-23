import SwiftUI
import CoreData

struct ProductCard: View {
    let managedProduct: NSManagedObject
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = managedProduct.value(forKey: "imageData") as? Data,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let category = managedProduct.value(forKey: "category") as? String {
                    Text(category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                
                Text(managedProduct.value(forKey: "name") as? String ?? "")
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack {
                    if let price = managedProduct.value(forKey: "price") as? Double {
                        Text(localizationManager.formatPrice(price))
                            .font(.title3.bold())
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text(managedProduct.value(forKey: "nicotineStrength") as? String ?? "")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding(12)
        }
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
} 