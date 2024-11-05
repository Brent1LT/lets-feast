import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 50)
            
            Text("Let's Feast!")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
            
                Image(systemName: "person.fill")
                    .foregroundColor(.primary)
                    .font(.system(size: 32))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .frame(width: 50, height: 50)
        }
        .padding(10)
    }
}


#Preview {
    HeaderView()
}

