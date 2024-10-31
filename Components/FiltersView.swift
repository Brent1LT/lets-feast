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
    
    @Binding var radius: Double
    @Binding var minPrice: Int
    @Binding var maxPrice: Int
    
    let priceRange = 0...4
    
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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Min Price: ")
                            .font(.subheadline)
                        HStack {
                            ForEach(priceRange, id: \.self) { index in
                                Button(action: {
                                    if index <= maxPrice {
                                        minPrice = index
                                    }
                                }) {
                                    Image(systemName: "dollarsign.circle")
                                        .foregroundColor(minPrice >= index ? .green : .gray)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Text("Max Price: ")
                            .font(.subheadline)
                        HStack {
                            ForEach(priceRange, id: \.self) { index in
                                Button(action: {
                                    if index >= minPrice {
                                        maxPrice = index // Update the maximum price
                                    }
                                }) {
                                    Image(systemName: "dollarsign.circle")
                                        .foregroundColor(maxPrice >= index ? .green : .gray)
                                }
                            }
                        }
                    }
                }
                .padding()
                .transition(.opacity)
            }
        }
        .onChange(of: selectedDistance) {
            radius = selectedDistance * 1609
        }
        .padding(10)
        
    }
}

// Wrapper View for Preview
struct FiltersViewWrapper: View {
    @State private var minPrice = 0
    @State private var maxPrice = 4
    @State private var radius: Double = 10000
    
    var body: some View {
        FiltersView(radius: $radius, minPrice: $minPrice, maxPrice: $maxPrice)
    }
}

#Preview {
    FiltersViewWrapper() // Use the wrapper view for the preview
}
