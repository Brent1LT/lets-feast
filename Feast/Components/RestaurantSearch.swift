import SwiftUI

struct RestaurantSearch: View {
    @Binding var searchText: String
    @FocusState private var isTextFieldFocused: Bool
    var submitRequest: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Find something to eat...", text: $searchText)
                        .padding(.horizontal)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            submitRequest()
                            isTextFieldFocused = false
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityIdentifier("Search query")
                    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Restaurants")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(height: 100)
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 5)
        )
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
