import SwiftUI

// MARK: - Product Model

class Product: Identifiable {
    let id: Int
    let name: String
    let productNumber: String
    let color: String
    let listPrice: Double
    
    init(
        id: Int,
        name: String,
        productNumber: String,
        color: String,
        listPrice: Double
    ) {
        self.id = id
        self.name = name
        self.productNumber = productNumber
        self.color = color
        self.listPrice = listPrice
    }
}

// MARK: - Product List View

struct ProductList: View {
    
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                NavigationLink(destination: ProductDetails(product: product)) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(product.name)
                            .font(.headline)
                        
                        Text("Color: \(product.color)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Products")
            .task {
                products = loadProducts()
            }
        }
    }
    
    // Hard-coded product loading function
    func loadProducts() -> [Product] {
        return [
            Product(
                id: 1,
                name: "iPhone 17",
                productNumber: "IPH17",
                color: "Black",
                listPrice: 799.00
            ),
            Product(
                id: 2,
                name: "iPad Air",
                productNumber: "IPAIR",
                color: "Blue",
                listPrice: 599.00
            ),
            Product(
                id: 3,
                name: "MacBook Air",
                productNumber: "MBA15",
                color: "Silver",
                listPrice: 999.00
            ),
            Product(
                id: 4,
                name: "Apple Watch",
                productNumber: "AW10",
                color: "Midnight",
                listPrice: 399.00
            )
        ]
    }
}

// MARK: - Product Details View

struct ProductDetails: View {
    
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text(product.name)
                .font(.largeTitle)
                .bold()
            
            Text("Product ID: \(product.id)")
            
            Text("Product Number: \(product.productNumber)")
            
            Text("Color: \(product.color)")
            
            Text("List Price: $\(product.listPrice, specifier: "%.2f")")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Main App

@main
struct Module06App: App {
    
    var body: some Scene {
        WindowGroup {
            ProductList()
        }
    }
}