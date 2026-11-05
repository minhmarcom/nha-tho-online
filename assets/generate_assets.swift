import Foundation
import CoreGraphics
import AppKit

func savePNG(image: CGImage, path: String) {
    let url = URL(fileURLWithPath: path)
    let nsImage = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
    if let tiff = nsImage.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
        if let png = rep.representation(using: .png, properties: [:]) {
            try? png.write(to: url)
            print("Wrote \(path)")
        }
    }
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
let dir = "/Users/minhmarcom/.gemini/antigravity/scratch/StudioLive/overlay/church-assets/"

// 1. fx_cross.png (300x400)
do {
    let w = 300, h = 400
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    let cy = CGFloat(h) / 2
    
    // Golden rays / halo background
    ctx.saveGState()
    for i in 0..<16 {
        let angle = CGFloat(i) * (.pi / 8)
        ctx.saveGState()
        ctx.translateBy(x: cx, y: cy + 40)
        ctx.rotate(by: angle)
        let rayGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 1.0, green: 0.9, blue: 0.4, alpha: 0.6),
            CGColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 0.0)
        ] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(rayGrad, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 140), options: [])
        ctx.restoreGState()
    }
    ctx.restoreGState()
    
    // Cross - Golden Wood
    let crossColor = CGColor(red: 0.85, green: 0.65, blue: 0.15, alpha: 1.0)
    let woodBorder = CGColor(red: 0.55, green: 0.35, blue: 0.05, alpha: 1.0)
    ctx.setFillColor(crossColor)
    ctx.setStrokeColor(woodBorder)
    ctx.setLineWidth(4)
    
    // Vertical beam: width 36, height 280
    let vertRect = CGRect(x: cx - 18, y: 40, width: 36, height: 280)
    ctx.fill(vertRect)
    ctx.stroke(vertRect)
    
    // Horizontal beam: width 190, height 36
    let horizRect = CGRect(x: cx - 95, y: 220, width: 190, height: 36)
    ctx.fill(horizRect)
    ctx.stroke(horizRect)
    
    // Center INRI plaque
    ctx.setFillColor(CGColor(red: 0.98, green: 0.95, blue: 0.85, alpha: 1.0))
    let inriRect = CGRect(x: cx - 22, y: 300, width: 44, height: 24)
    ctx.fill(inriRect)
    ctx.stroke(inriRect)
    
    // Radiant center star/heart
    ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.7, alpha: 0.9))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 220, width: 36, height: 36))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "fx_cross.png")
    }
}

// 2. fx_dove.png (Holy Spirit Dove) (320x320)
do {
    let w = 320, h = 320
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    let cy = CGFloat(h) / 2
    
    // Light glow behind dove
    let glow = CGGradient(colorsSpace: colorSpace, colors: [
        CGColor(red: 1.0, green: 0.98, blue: 0.8, alpha: 0.7),
        CGColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 0.0)
    ] as CFArray, locations: [0, 1])!
    ctx.drawRadialGradient(glow, startCenter: CGPoint(x: cx, y: cy), startRadius: 10, endCenter: CGPoint(x: cx, y: cy), endRadius: 140, options: [])
    
    // White dove wings & body
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 0.95))
    ctx.setStrokeColor(CGColor(red: 0.8, green: 0.85, blue: 0.95, alpha: 1.0))
    ctx.setLineWidth(2.5)
    
    // Left Wing
    let leftWing = CGMutablePath()
    leftWing.move(to: CGPoint(x: cx - 15, y: cy + 10))
    leftWing.addQuadCurve(to: CGPoint(x: cx - 120, y: cy + 90), control: CGPoint(x: cx - 70, y: cy + 110))
    leftWing.addQuadCurve(to: CGPoint(x: cx - 80, y: cy + 30), control: CGPoint(x: cx - 100, y: cy + 50))
    leftWing.addQuadCurve(to: CGPoint(x: cx - 15, y: cy - 10), control: CGPoint(x: cx - 50, y: cy + 10))
    leftWing.closeSubpath()
    ctx.addPath(leftWing)
    ctx.drawPath(using: .fillStroke)
    
    // Right Wing
    let rightWing = CGMutablePath()
    rightWing.move(to: CGPoint(x: cx + 15, y: cy + 10))
    rightWing.addQuadCurve(to: CGPoint(x: cx + 120, y: cy + 90), control: CGPoint(x: cx + 70, y: cy + 110))
    rightWing.addQuadCurve(to: CGPoint(x: cx + 80, y: cy + 30), control: CGPoint(x: cx + 100, y: cy + 50))
    rightWing.addQuadCurve(to: CGPoint(x: cx + 15, y: cy - 10), control: CGPoint(x: cx + 50, y: cy + 10))
    rightWing.closeSubpath()
    ctx.addPath(rightWing)
    ctx.drawPath(using: .fillStroke)
    
    // Body & Tail
    let body = CGMutablePath()
    body.move(to: CGPoint(x: cx, y: cy + 45)) // head
    body.addQuadCurve(to: CGPoint(x: cx + 22, y: cy - 20), control: CGPoint(x: cx + 26, y: cy + 10))
    body.addQuadCurve(to: CGPoint(x: cx + 18, y: cy - 75), control: CGPoint(x: cx + 25, y: cy - 50)) // tail right
    body.addLine(to: CGPoint(x: cx, y: cy - 55)) // tail center
    body.addLine(to: CGPoint(x: cx - 18, y: cy - 75)) // tail left
    body.addQuadCurve(to: CGPoint(x: cx - 22, y: cy - 20), control: CGPoint(x: cx - 25, y: cy - 50))
    body.addQuadCurve(to: CGPoint(x: cx, y: cy + 45), control: CGPoint(x: cx - 26, y: cy + 10))
    body.closeSubpath()
    ctx.addPath(body)
    ctx.drawPath(using: .fillStroke)
    
    // Head & Beak
    ctx.fillEllipse(in: CGRect(x: cx - 14, y: cy + 30, width: 28, height: 32))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.75, blue: 0.2, alpha: 1.0))
    let beak = CGMutablePath()
    beak.move(to: CGPoint(x: cx - 4, y: cy + 58))
    beak.addLine(to: CGPoint(x: cx, y: cy + 72))
    beak.addLine(to: CGPoint(x: cx + 4, y: cy + 58))
    beak.closeSubpath()
    ctx.addPath(beak)
    ctx.fillPath()
    
    // Olive branch in beak (Green)
    ctx.setStrokeColor(CGColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0))
    ctx.setLineWidth(3)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: cx, y: cy + 65))
    ctx.addQuadCurve(to: CGPoint(x: cx + 32, y: cy + 78), control: CGPoint(x: cx + 18, y: cy + 76))
    ctx.strokePath()
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "fx_dove.png")
    }
}

// 3. fx_candle.png (Church Candle with burning flame) (200x320)
do {
    let w = 200, h = 320
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    
    // Candle wax body (White / ivory pillar candle)
    let bodyRect = CGRect(x: cx - 28, y: 20, width: 56, height: 180)
    ctx.setFillColor(CGColor(red: 0.97, green: 0.95, blue: 0.90, alpha: 1.0))
    ctx.fill(bodyRect)
    ctx.setStrokeColor(CGColor(red: 0.85, green: 0.80, blue: 0.70, alpha: 1.0))
    ctx.setLineWidth(2)
    ctx.stroke(bodyRect)
    
    // Gold base / stand
    ctx.setFillColor(CGColor(red: 0.88, green: 0.72, blue: 0.2, alpha: 1.0))
    let baseRect = CGRect(x: cx - 44, y: 10, width: 88, height: 16)
    ctx.fill(baseRect)
    
    // Wick
    ctx.setStrokeColor(CGColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 1.0))
    ctx.setLineWidth(3)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: cx, y: 200))
    ctx.addLine(to: CGPoint(x: cx, y: 220))
    ctx.strokePath()
    
    // Halo glow around flame
    let flameGlow = CGGradient(colorsSpace: colorSpace, colors: [
        CGColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 0.8),
        CGColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 0.0)
    ] as CFArray, locations: [0, 1])!
    ctx.drawRadialGradient(flameGlow, startCenter: CGPoint(x: cx, y: 245), startRadius: 5, endCenter: CGPoint(x: cx, y: 245), endRadius: 65, options: [])
    
    // Flame teardrop
    let flame = CGMutablePath()
    flame.move(to: CGPoint(x: cx, y: 275)) // top point
    flame.addQuadCurve(to: CGPoint(x: cx + 14, y: 230), control: CGPoint(x: cx + 18, y: 255))
    flame.addQuadCurve(to: CGPoint(x: cx, y: 216), control: CGPoint(x: cx + 10, y: 218))
    flame.addQuadCurve(to: CGPoint(x: cx - 14, y: 230), control: CGPoint(x: cx - 10, y: 218))
    flame.addQuadCurve(to: CGPoint(x: cx, y: 275), control: CGPoint(x: cx - 18, y: 255))
    flame.closeSubpath()
    ctx.addPath(flame)
    ctx.setFillColor(CGColor(red: 1.0, green: 0.65, blue: 0.1, alpha: 0.95))
    ctx.fillPath()
    
    // Inner bright white-yellow flame core
    ctx.setFillColor(CGColor(red: 1.0, green: 0.96, blue: 0.8, alpha: 0.95))
    ctx.fillEllipse(in: CGRect(x: cx - 7, y: 224, width: 14, height: 26))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "fx_candle.png")
    }
}

// 4. fx_rose.png (Sacred Rose of Grace) (260x260)
do {
    let w = 260, h = 260
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    let cy = CGFloat(h) / 2
    
    // Leaves
    ctx.setFillColor(CGColor(red: 0.25, green: 0.65, blue: 0.25, alpha: 1.0))
    let leaf1 = CGMutablePath()
    leaf1.move(to: CGPoint(x: cx - 30, y: cy - 20))
    leaf1.addQuadCurve(to: CGPoint(x: cx - 85, y: cy - 50), control: CGPoint(x: cx - 70, y: cy - 10))
    leaf1.addQuadCurve(to: CGPoint(x: cx - 30, y: cy - 20), control: CGPoint(x: cx - 55, y: cy - 60))
    ctx.addPath(leaf1)
    ctx.fillPath()
    
    let leaf2 = CGMutablePath()
    leaf2.move(to: CGPoint(x: cx + 30, y: cy - 20))
    leaf2.addQuadCurve(to: CGPoint(x: cx + 85, y: cy - 50), control: CGPoint(x: cx + 70, y: cy - 10))
    leaf2.addQuadCurve(to: CGPoint(x: cx + 30, y: cy - 20), control: CGPoint(x: cx + 55, y: cy - 60))
    ctx.addPath(leaf2)
    ctx.fillPath()
    
    // Rose petals (outer to inner)
    let colors = [
        CGColor(red: 0.82, green: 0.10, blue: 0.22, alpha: 1.0),
        CGColor(red: 0.90, green: 0.15, blue: 0.28, alpha: 1.0),
        CGColor(red: 0.98, green: 0.25, blue: 0.38, alpha: 1.0),
        CGColor(red: 1.00, green: 0.45, blue: 0.55, alpha: 1.0)
    ]
    
    for i in 0..<4 {
        let r = CGFloat(70 - i * 15)
        ctx.setFillColor(colors[i])
        for p in 0..<6 {
            let angle = CGFloat(p) * (.pi / 3) + CGFloat(i) * 0.4
            let px = cx + cos(angle) * (r * 0.45)
            let py = cy + sin(angle) * (r * 0.45)
            ctx.fillEllipse(in: CGRect(x: px - r * 0.6, y: py - r * 0.6, width: r * 1.2, height: r * 1.2))
        }
    }
    
    // Center bud
    ctx.setFillColor(CGColor(red: 0.70, green: 0.05, blue: 0.15, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: cy - 18, width: 36, height: 36))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "fx_rose.png")
    }
}

// 5. fx_church_bell.png (Golden bronze church bell) (280x280)
do {
    let w = 280, h = 280
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    
    // Bell top ring
    ctx.setStrokeColor(CGColor(red: 0.65, green: 0.45, blue: 0.15, alpha: 1.0))
    ctx.setLineWidth(8)
    ctx.strokeEllipse(in: CGRect(x: cx - 22, y: 220, width: 44, height: 44))
    
    // Bronze bell gradient
    let bellGrad = CGGradient(colorsSpace: colorSpace, colors: [
        CGColor(red: 0.98, green: 0.82, blue: 0.35, alpha: 1.0),
        CGColor(red: 0.80, green: 0.55, blue: 0.15, alpha: 1.0),
        CGColor(red: 0.60, green: 0.38, blue: 0.08, alpha: 1.0)
    ] as CFArray, locations: [0.0, 0.5, 1.0])!
    
    let bellPath = CGMutablePath()
    bellPath.move(to: CGPoint(x: cx - 26, y: 220)) // top left
    bellPath.addQuadCurve(to: CGPoint(x: cx - 95, y: 65), control: CGPoint(x: cx - 42, y: 130))
    bellPath.addQuadCurve(to: CGPoint(x: cx - 105, y: 45), control: CGPoint(x: cx - 105, y: 55))
    bellPath.addLine(to: CGPoint(x: cx + 105, y: 45))
    bellPath.addQuadCurve(to: CGPoint(x: cx + 95, y: 65), control: CGPoint(x: cx + 105, y: 55))
    bellPath.addQuadCurve(to: CGPoint(x: cx + 26, y: 220), control: CGPoint(x: cx + 42, y: 130))
    bellPath.closeSubpath()
    
    ctx.saveGState()
    ctx.addPath(bellPath)
    ctx.clip()
    ctx.drawLinearGradient(bellGrad, start: CGPoint(x: cx - 100, y: 140), end: CGPoint(x: cx + 100, y: 140), options: [])
    ctx.restoreGState()
    
    // Bottom lip of bell
    ctx.setFillColor(CGColor(red: 0.72, green: 0.48, blue: 0.12, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 102, y: 34, width: 204, height: 26))
    
    // Clapper inside bell
    ctx.setFillColor(CGColor(red: 0.4, green: 0.25, blue: 0.08, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 16, y: 24, width: 32, height: 32))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "fx_church_bell.png")
    }
}

// 6. Character sprites for Priest, Altar Server, Eucharistic Youth
// Priest (c_priest.png)
do {
    let w = 212, h = 300
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    
    // Red Liturgical Chasuble (Áo Lễ Đỏ như trong ảnh 1)
    let chasuble = CGMutablePath()
    chasuble.move(to: CGPoint(x: cx - 22, y: 235)) // collar left
    chasuble.addQuadCurve(to: CGPoint(x: cx - 75, y: 150), control: CGPoint(x: cx - 60, y: 220)) // left shoulder/sleeve
    chasuble.addQuadCurve(to: CGPoint(x: cx - 65, y: 25), control: CGPoint(x: cx - 75, y: 80)) // bottom left
    chasuble.addQuadCurve(to: CGPoint(x: cx + 65, y: 25), control: CGPoint(x: cx, y: 15)) // hem bottom
    chasuble.addQuadCurve(to: CGPoint(x: cx + 75, y: 150), control: CGPoint(x: cx + 75, y: 80)) // bottom right
    chasuble.addQuadCurve(to: CGPoint(x: cx + 22, y: 235), control: CGPoint(x: cx + 60, y: 220)) // right shoulder
    chasuble.closeSubpath()
    
    ctx.setFillColor(CGColor(red: 0.85, green: 0.15, blue: 0.18, alpha: 1.0)) // Red vestment
    ctx.addPath(chasuble)
    ctx.fillPath()
    
    // Gold cross orphrey on chasuble
    ctx.setFillColor(CGColor(red: 0.98, green: 0.82, blue: 0.25, alpha: 1.0))
    let orphrey = CGRect(x: cx - 12, y: 25, width: 24, height: 210)
    ctx.fill(orphrey)
    let orphreyBar = CGRect(x: cx - 36, y: 165, width: 72, height: 22)
    ctx.fill(orphreyBar)
    
    // White alb showing underneath
    ctx.setFillColor(CGColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 55, y: 5, width: 110, height: 25))
    
    // Priest Head
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 24, y: 228, width: 48, height: 56))
    
    // Black clerical collar with white tab
    ctx.setFillColor(CGColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 20, y: 225, width: 40, height: 12))
    ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 5, y: 227, width: 10, height: 8))
    
    // Hair
    ctx.setFillColor(CGColor(red: 0.2, green: 0.18, blue: 0.16, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 25, y: 260, width: 50, height: 28))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "c_priest.png")
    }
}

// Altar Server (c_altar_server.png) - White cassock & surplice (Lễ sinh áo trắng)
do {
    let w = 212, h = 300
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    
    // White Alb / Surplice
    ctx.setFillColor(CGColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0))
    let robe = CGMutablePath()
    robe.move(to: CGPoint(x: cx - 20, y: 225))
    robe.addLine(to: CGPoint(x: cx - 60, y: 150))
    robe.addLine(to: CGPoint(x: cx - 50, y: 20))
    robe.addLine(to: CGPoint(x: cx + 50, y: 20))
    robe.addLine(to: CGPoint(x: cx + 60, y: 150))
    robe.addLine(to: CGPoint(x: cx + 20, y: 225))
    robe.closeSubpath()
    ctx.addPath(robe)
    ctx.fillPath()
    
    // Red collar / shoulder cape (như lễ sinh nhà thờ)
    ctx.setFillColor(CGColor(red: 0.80, green: 0.15, blue: 0.18, alpha: 1.0))
    let cape = CGMutablePath()
    cape.move(to: CGPoint(x: cx - 20, y: 225))
    cape.addQuadCurve(to: CGPoint(x: cx - 42, y: 180), control: CGPoint(x: cx - 36, y: 210))
    cape.addQuadCurve(to: CGPoint(x: cx + 42, y: 180), control: CGPoint(x: cx, y: 170))
    cape.addQuadCurve(to: CGPoint(x: cx + 20, y: 225), control: CGPoint(x: cx + 36, y: 210))
    cape.closeSubpath()
    ctx.addPath(cape)
    ctx.fillPath()
    
    // Hands holding prayer candle
    ctx.setFillColor(CGColor(red: 0.95, green: 0.78, blue: 0.65, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 14, y: 125, width: 28, height: 20))
    
    // Tall candle in hands
    ctx.setFillColor(CGColor(red: 0.85, green: 0.65, blue: 0.2, alpha: 1.0)) // gold pole
    ctx.fill(CGRect(x: cx - 3, y: 30, width: 6, height: 180))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)) // flame
    ctx.fillEllipse(in: CGRect(x: cx - 6, y: 210, width: 12, height: 20))
    
    // Altar boy head
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 225, width: 40, height: 48))
    ctx.setFillColor(CGColor(red: 0.2, green: 0.15, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 22, y: 252, width: 44, height: 25))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "c_altar_server.png")
    }
}

// Eucharistic Youth (c_eucharist.png) - Thiếu Nhi Thánh Thể (Áo trắng + khăn quàng vàng)
do {
    let w = 212, h = 300
    let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let cx = CGFloat(w) / 2
    
    // Dark trousers / skirt
    ctx.setFillColor(CGColor(red: 0.18, green: 0.20, blue: 0.24, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 38, y: 15, width: 76, height: 110))
    
    // White shirt (Áo sơ mi trắng)
    ctx.setFillColor(CGColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0))
    let shirt = CGMutablePath()
    shirt.move(to: CGPoint(x: cx - 20, y: 220))
    shirt.addLine(to: CGPoint(x: cx - 55, y: 160))
    shirt.addLine(to: CGPoint(x: cx - 42, y: 120))
    shirt.addLine(to: CGPoint(x: cx + 42, y: 120))
    shirt.addLine(to: CGPoint(x: cx + 55, y: 160))
    shirt.addLine(to: CGPoint(x: cx + 20, y: 220))
    shirt.closeSubpath()
    ctx.addPath(shirt)
    ctx.fillPath()
    
    // Yellow Scarf (Khăn quàng Thiếu Nhi Thánh Thể màu vàng viền đỏ như trong ảnh 1)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.82, blue: 0.15, alpha: 1.0))
    let scarf = CGMutablePath()
    scarf.move(to: CGPoint(x: cx - 22, y: 220))
    scarf.addLine(to: CGPoint(x: cx, y: 155)) // scarf knot/tail
    scarf.addLine(to: CGPoint(x: cx + 22, y: 220))
    scarf.closeSubpath()
    ctx.addPath(scarf)
    ctx.fillPath()
    
    // Red border on scarf
    ctx.setStrokeColor(CGColor(red: 0.85, green: 0.15, blue: 0.18, alpha: 1.0))
    ctx.setLineWidth(2.5)
    ctx.strokePath()
    
    // Head
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 220, width: 40, height: 48))
    ctx.setFillColor(CGColor(red: 0.18, green: 0.14, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 22, y: 248, width: 44, height: 26))
    
    if let img = ctx.makeImage() {
        savePNG(image: img, path: dir + "c_eucharist.png")
    }
}

print("All Catholic assets generated successfully!")
