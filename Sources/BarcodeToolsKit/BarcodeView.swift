import SwiftUI

/// A SwiftUI view that generates and displays barcodes.
///
/// This struct supports EAN-13 and EAN-8 barcode formats. It also provides
/// a customizable view for invalid barcodes.
///
/// Example usage:
/// ```swift
/// BarcodeView(barcode: .ean13("6410405176059"))
/// ```
public struct BarcodeView<InvalidView: View>: View {
    let barcode: Barcode?
    let invalidBarcodeView: () -> InvalidView

    public init(
        barcode: Barcode,
        @ViewBuilder invalidBarcodeView: @escaping () -> InvalidView = { EmptyView() }
    ) {
        self.barcode = barcode
        self.invalidBarcodeView = invalidBarcodeView
    }

    public init(
        barcode: String,
        @ViewBuilder invalidBarcodeView: @escaping () -> InvalidView = { EmptyView() }
    ) {
        self.barcode = .init(rawValue: barcode)
        self.invalidBarcodeView = invalidBarcodeView
    }

    public var body: some View {
        if let barcode, barcode.isValid {
            Group {
                switch barcode {
                case let .ean13(code):
                    EAN13(barcode: code)
                case let .ean8(code):
                    EAN8(barcode: code)
                }
            }
        } else {
            invalidBarcodeView()
        }
    }
}

public extension EnvironmentValues {
    @Entry var barcodeLineColor: Color = .accentColor
}

public extension View {
    func barcodeLineColor(_ color: Color) -> some View {
        environment(\.barcodeLineColor, color)
    }
}

#Preview {
    VStack(spacing: 20) {
        BarcodeView(barcode: .ean13("6410405176059"))
            .frame(width: 200, height: 100)
            .barcodeLineColor(.red)
        BarcodeView(barcode: .ean8("20886509"))
            .frame(width: 200, height: 100)
            .barcodeLineColor(.blue)
        BarcodeView(barcode: .ean8("12345678")) {
            Text("INVALID")
        }
        .frame(width: 200, height: 100)
    }
}
