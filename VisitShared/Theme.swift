import SwiftUI

// MARK: - Liquid Glass Theme

struct LiquidGlass {
    // Core materials
    static let ultraThin = Material.ultraThinMaterial
    static let thin = Material.thinMaterial
    static let regular = Material.regularMaterial
    static let thick = Material.thickMaterial
    
    // Accent
    static let accent = Color.accentColor
    static let secondaryAccent = Color.blue.opacity(0.8)
    
    // Text
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    
    // Background gradient for depth
    static var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.systemBackground).opacity(0.95),
                Color.blue.opacity(0.03)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Glass Card Modifier

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 0.5)
            }
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20, padding: CGFloat = 16) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - Pillar Header Style

struct PillarHeader: View {
    let pillar: Pillar
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: pillar.icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(pillar.rawValue)
                    .font(.headline.weight(.semibold))
                Text(pillar.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}
