//
//  FiltersView.swift
//  Feast
//
//  Created by Brent Bumann on 9/3/24.
//

import SwiftUI

struct FiltersView: View {
    @State private var selectedDistance: Double = 10.0
    @State private var showFilters: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Filters")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        showFilters.toggle()
                    }
                }) {
                    Image(systemName: showFilters ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
            }

            if (showFilters) {
                VStack(alignment: .leading) {
                    Text("Distance: \(Int(selectedDistance)) miles")
                        .font(.subheadline)
                    
                    Slider(value: $selectedDistance, in: 1...50, step: 1)
                        .accentColor(.blue)
                        .padding(.vertical, 10)
                }
                .padding()
                .transition(.opacity)
            }
        }
        .padding(10)
    }
}

#Preview {
    FiltersView()
}
