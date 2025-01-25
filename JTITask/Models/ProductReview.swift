import Foundation

struct ProductReview: Identifiable {
    let id = UUID()
    let userName: String
    let rating: Int
    let comment: String
    let date: Date
} 