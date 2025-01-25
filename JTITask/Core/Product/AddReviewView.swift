import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProductDetailViewModel
    let product: Product
    
    @State private var rating: Int = 5
    @State private var comment: String = ""
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                Form {
                    Section("Değerlendirme") {
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                    .onTapGesture {
                                        withAnimation {
                                            rating = index
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    
                    Section("Yorumunuz") {
                        TextEditor(text: $comment)
                            .frame(height: 100)
                    }
                    
                    Section {
                        Button("Yorumu Gönder") {
                            if !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                viewModel.addReview(
                                    ProductReview(
                                        userName: "Kullanıcı",
                                        rating: rating,
                                        comment: comment,
                                        date: Date()
                                    )
                                )
                                dismiss()
                            } else {
                                showError = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Yorum Yaz")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("İptal") {
                            dismiss()
                        }
                    }
                }
                .alert("Hata", isPresented: $showError) {
                    Button("Tamam", role: .cancel) { }
                } message: {
                    Text("Lütfen bir yorum yazın.")
                }
            }
        }
    }
} 