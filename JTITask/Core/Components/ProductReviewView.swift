import SwiftUI

struct ProductReviewView: View {
    let review: ProductReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Kullanıcı adı ve tarih
                VStack(alignment: .leading) {
                    Text(review.userName)
                        .font(.headline)
                    Text(review.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Yıldız değerlendirmesi
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            
            // Yorum metni
            Text(review.comment)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
} 