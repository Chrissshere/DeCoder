import SwiftUI

struct FormatSelectionView: View {
    @Binding var selectedFormat: ConversionFormat
    
    // Use fixed 2-column grid
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ConversionFormat.allCases) { format in
                    FormatCard(format: format, isSelected: format == selectedFormat)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedFormat = format
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

struct FormatCard: View {
    let format: ConversionFormat
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icon at the top
            Image(systemName: format.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(isSelected ? .white : .blue)
                .frame(width: 32, height: 32)
            
            // Title
            Text(format.rawValue)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
            
            // Description
            Text(format.description)
                .font(.caption)
                .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue : Color(.systemBackground))
                .shadow(color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.1),
                       radius: isSelected ? 8 : 4,
                       x: 0,
                       y: isSelected ? 4 : 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color(.systemGray5), lineWidth: 1)
        )
    }
}

#Preview {
    FormatSelectionView(selectedFormat: .constant(.morse))
} 