//
//  Extensions.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 07/01/2021.
//

import SwiftUI

extension View {
    /// This method adds rounded border to the view
    /// - Parameters:
    ///   - content: Shape turned into view. Color can also be applied there.
    ///   - width: border width
    ///   - cornerRadius: value of rounded corners
    /// - Returns: view with rounded border
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

// MARK: Color Management
// MARK: - Color
extension Color {
    /// This function gets color elements.
    /// - Returns:
    ///   - r: red value
    ///   - g: green value
    ///   - b: blue value
    ///   - a: alpha value
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 255.0, g: CGFloat = 255.0, b: CGFloat = 255.0, a: CGFloat = 1.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        
        return (r, g, b, a)
    }
}

extension Color {
    /// This function converts Color to the NSColor.
    /// - Returns: NSColor
    func nsColor() -> NSColor {
        if #available(macOS 10.15, *) {
            return NSColor(self)
        }
        
        let components = self.components()
        return NSColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
}

// MARK: - NSColor
extension NSColor {
    /// This function converts NSColor to a hexadecimal color string.
    /// - Returns: Hexadecimal Color String
    func toHexString() -> String? {
        var alpha = false
        
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a < 1 {
            alpha = true
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension NSColor {
    /// This computed property returns a Hue-Saturation-Brightness value.
    var hsbColor: HSBColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return HSBColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
}

extension NSColor {
    public struct HSBColor {
        var hue: CGFloat
        var saturation: CGFloat
        var brightness: CGFloat
        var alpha: CGFloat
        
        var uiColor: NSColor {
            get {
                return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
            }
        }
    }
}

/// Convert hexadecimal color string to the NSColor.
extension NSColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: - Hide List Indicator
extension View {
    func onNSView(added: @escaping (NSView) -> Void) -> some View {
        NSViewAccessor(onNSViewAdded: added) { self }
    }
}

struct NSViewAccessor<Content>: NSViewRepresentable where Content: View {
    var onNSView: (NSView) -> Void
    var viewBuilder: () -> Content
    
    init(onNSViewAdded: @escaping (NSView) -> Void, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.onNSView = onNSViewAdded
        self.viewBuilder = viewBuilder
    }
    
    func makeNSView(context: Context) -> NSViewAccessorHosting<Content> {
        return NSViewAccessorHosting(onNSView: onNSView, rootView: self.viewBuilder())
    }
    
    func updateNSView(_ nsView: NSViewAccessorHosting<Content>, context: Context) {
        nsView.rootView = self.viewBuilder()
    }
}

class NSViewAccessorHosting<Content>: NSHostingView<Content> where Content : View {
    var onNSView: ((NSView) -> Void)
    
    init(onNSView: @escaping (NSView) -> Void, rootView: Content) {
        self.onNSView = onNSView
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
        onNSView(subview)
    }
}
