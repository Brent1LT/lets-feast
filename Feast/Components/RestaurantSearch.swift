import SwiftUI

struct RestaurantSearch: View {
    @Binding var searchText: String
    @FocusState private var isTextFieldFocused: Bool
    var submitRequest: () -> Void
    
    @State private var placeholderIndex = 0
    @State private var animatedOpacity: Double = 1.0
    private let placeholders = [
        "Find something to eat...",
        "Try: Food by the beach...",
        "Try: Italian restaurants nearby...",
        "Try: Vegan options downtown..."
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Restaurants")
                    .fontWeight(.bold)
                    .padding(.leading, 15.0)
                
                HStack {
                    TextField(currentPlaceholder, text: $searchText)
                        .padding(.horizontal)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            submitRequest()
                            isTextFieldFocused = false
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityIdentifier("Search query")
                        .onAppear {
                            startPlaceholderRotation()
                        }
                        .opacity(animatedOpacity)
                    
                    Button(action: {
                        submitRequest()
                        isTextFieldFocused = false
                    }) {
                        Text("Search")
                            .padding(5.0)
                            .frame(height: 35.0)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .accessibilityIdentifier("Search for restaurants")
                }
                Spacer()
            }
            .padding(.trailing)
        }
        .frame(height: 100)
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 5)
        )
        
    }
    
    private var currentPlaceholder: String {
        placeholders[placeholderIndex % placeholders.count]
    }
    
    private func startPlaceholderRotation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                placeholderIndex += 1
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    @State var searchText = ""
    
    return RestaurantSearch(
        searchText: $searchText,
        submitRequest: {
            print("Submit button tapped or Return key pressed with search text:", searchText)
        }
    )
}
