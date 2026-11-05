import Foundation
import CoreGraphics
import AppKit

func generateVectorGameBackgrounds() {
    let targetW: CGFloat = 1080
    let targetH: CGFloat = 1920
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let outDir = "/Users/minhmarcom/.gemini/antigravity/scratch/NhaThoOnline/assets/"
    
    // --- 1. GAME ART: SANCTUARY INTERIOR (game_altar.png) ---
    do {
        let ctx = CGContext(data: nil, width: Int(targetW), height: Int(targetH), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        // Deep cathedral background gradient (warm amber-indigo cathedral hall)
        let bgGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.12, green: 0.08, blue: 0.16, alpha: 1.0),
            CGColor(red: 0.22, green: 0.14, blue: 0.20, alpha: 1.0),
            CGColor(red: 0.32, green: 0.22, blue: 0.18, alpha: 1.0)
        ] as CFArray, locations: [0.0, 0.5, 1.0])!
        ctx.drawLinearGradient(bgGrad, start: CGPoint(x: 540, y: targetH), end: CGPoint(x: 540, y: 0), options: [])
        
        // Gothic pointed arch wall (warm cathedral cream wall)
        let archPath = CGMutablePath()
        archPath.move(to: CGPoint(x: 80, y: 0))
        archPath.addLine(to: CGPoint(x: 80, y: 1300))
        archPath.addQuadCurve(to: CGPoint(x: 540, y: 1750), control: CGPoint(x: 120, y: 1680))
        archPath.addQuadCurve(to: CGPoint(x: 1000, y: 1300), control: CGPoint(x: 960, y: 1680))
        archPath.addLine(to: CGPoint(x: 1000, y: 0))
        archPath.closeSubpath()
        
        ctx.saveGState()
        let wallGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.94, green: 0.90, blue: 0.82, alpha: 1.0),
            CGColor(red: 0.86, green: 0.80, blue: 0.70, alpha: 1.0),
            CGColor(red: 0.75, green: 0.68, blue: 0.56, alpha: 1.0)
        ] as CFArray, locations: [0.0, 0.6, 1.0])!
        ctx.addPath(archPath)
        ctx.clip()
        ctx.drawLinearGradient(wallGrad, start: CGPoint(x: 540, y: 1750), end: CGPoint(x: 540, y: 0), options: [])
        
        // Inner Gothic Arch Trim
        ctx.setStrokeColor(CGColor(red: 0.60, green: 0.45, blue: 0.30, alpha: 0.7))
        ctx.setLineWidth(14)
        ctx.addPath(archPath)
        ctx.strokePath()
        ctx.restoreGState()
        
        // Stained Glass Rose Window (Cửa sổ kính màu) near the apex (y = 1550 in CG coordinates)
        let winCX: CGFloat = 540
        let winCY: CGFloat = 1520
        let winR: CGFloat = 130
        
        // Window halo
        let winGlow = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 0.7),
            CGColor(red: 0.8, green: 0.4, blue: 0.9, alpha: 0.0)
        ] as CFArray, locations: [0, 1])!
        ctx.drawRadialGradient(winGlow, startCenter: CGPoint(x: winCX, y: winCY), startRadius: 10, endCenter: CGPoint(x: winCX, y: winCY), endRadius: 280, options: [])
        
        // Rose Window Segments (Ruby red, Cobalt blue, Amber gold, Emerald green)
        let colors = [
            CGColor(red: 0.85, green: 0.15, blue: 0.25, alpha: 0.9),
            CGColor(red: 0.15, green: 0.45, blue: 0.90, alpha: 0.9),
            CGColor(red: 0.95, green: 0.75, blue: 0.15, alpha: 0.9),
            CGColor(red: 0.15, green: 0.75, blue: 0.45, alpha: 0.9)
        ]
        for p in 0..<12 {
            let a1 = CGFloat(p) * (.pi / 6)
            let a2 = CGFloat(p + 1) * (.pi / 6)
            let petal = CGMutablePath()
            petal.move(to: CGPoint(x: winCX, y: winCY))
            petal.addArc(center: CGPoint(x: winCX, y: winCY), radius: winR, startAngle: a1, endAngle: a2, clockwise: false)
            petal.closeSubpath()
            ctx.setFillColor(colors[p % 4])
            ctx.addPath(petal)
            ctx.fillPath()
        }
        
        // Stone tracery frame around window
        ctx.setStrokeColor(CGColor(red: 0.35, green: 0.25, blue: 0.20, alpha: 1.0))
        ctx.setLineWidth(10)
        ctx.strokeEllipse(in: CGRect(x: winCX - winR, y: winCY - winR, width: winR * 2, height: winR * 2))
        ctx.setLineWidth(4)
        ctx.strokeEllipse(in: CGRect(x: winCX - winR * 0.45, y: winCY - winR * 0.45, width: winR * 0.9, height: winR * 0.9))
        
        // Central Golden Crucifix (Thánh Giá Cung Thánh)
        let crossY: CGFloat = 1180
        let crossGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 1.0, green: 0.88, blue: 0.4, alpha: 0.9),
            CGColor(red: 0.8, green: 0.5, blue: 0.1, alpha: 0.0)
        ] as CFArray, locations: [0, 1])!
        ctx.drawRadialGradient(crossGrad, startCenter: CGPoint(x: 540, y: crossY + 50), startRadius: 10, endCenter: CGPoint(x: 540, y: crossY + 50), endRadius: 220, options: [])
        
        // Wooden Cross
        ctx.setFillColor(CGColor(red: 0.48, green: 0.28, blue: 0.12, alpha: 1.0))
        ctx.setStrokeColor(CGColor(red: 0.85, green: 0.65, blue: 0.20, alpha: 1.0))
        ctx.setLineWidth(5)
        
        let vertBeam = CGRect(x: 540 - 24, y: crossY - 140, width: 48, height: 380)
        ctx.fill(vertBeam); ctx.stroke(vertBeam)
        let horizBeam = CGRect(x: 540 - 130, y: crossY + 90, width: 260, height: 48)
        ctx.fill(horizBeam); ctx.stroke(horizBeam)
        
        // Christ silhouette on cross (Stylized game gold figure)
        ctx.setFillColor(CGColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1.0))
        ctx.fillEllipse(in: CGRect(x: 540 - 18, y: crossY + 110, width: 36, height: 40)) // head
        let corpus = CGRect(x: 540 - 16, y: crossY - 40, width: 32, height: 160)
        ctx.fill(corpus)
        
        // Altar Steps & Table (Bàn Thờ Cung Thánh)
        // Steps
        let stepColor1 = CGColor(red: 0.82, green: 0.76, blue: 0.65, alpha: 1.0)
        let stepColor2 = CGColor(red: 0.68, green: 0.60, blue: 0.48, alpha: 1.0)
        for s in 0..<3 {
            let sy: CGFloat = 860 - CGFloat(s) * 35
            let sw: CGFloat = 780 + CGFloat(s) * 80
            ctx.setFillColor(s % 2 == 0 ? stepColor1 : stepColor2)
            ctx.fill(CGRect(x: 540 - sw/2, y: sy, width: sw, height: 35))
        }
        
        // Altar Table (Bàn Thờ)
        let altarW: CGFloat = 620
        let altarH: CGFloat = 130
        let altarY: CGFloat = 890
        
        // White Linen Altar Cloth
        ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
        ctx.fill(CGRect(x: 540 - altarW/2, y: altarY, width: altarW, height: altarH))
        
        // Gold embroidered border on altar cloth
        ctx.setFillColor(CGColor(red: 0.90, green: 0.75, blue: 0.25, alpha: 1.0))
        ctx.fill(CGRect(x: 540 - altarW/2, y: altarY + altarH - 16, width: altarW, height: 16))
        ctx.fill(CGRect(x: 540 - altarW/2, y: altarY, width: altarW, height: 14))
        
        // Latin Cross in center of altar cloth
        let altarCrossW = CGRect(x: 540 - 8, y: altarY + 25, width: 16, height: 75)
        let altarCrossH = CGRect(x: 540 - 28, y: altarY + 60, width: 56, height: 16)
        ctx.fill(altarCrossW); ctx.fill(altarCrossH)
        
        // Two Golden Candelabras with burning candles on Altar
        for cx in [540 - 220, 540 + 220] {
            let candX = CGFloat(cx)
            ctx.setFillColor(CGColor(red: 0.85, green: 0.70, blue: 0.20, alpha: 1.0))
            ctx.fill(CGRect(x: candX - 8, y: altarY + altarH, width: 16, height: 80)) // stand
            ctx.fill(CGRect(x: candX - 25, y: altarY + altarH, width: 50, height: 14)) // base
            ctx.setFillColor(CGColor(red: 0.96, green: 0.95, blue: 0.90, alpha: 1.0))
            ctx.fill(CGRect(x: candX - 10, y: altarY + altarH + 80, width: 20, height: 90)) // candle
            
            // Flame Glow
            let flameGlow = CGGradient(colorsSpace: colorSpace, colors: [
                CGColor(red: 1.0, green: 0.85, blue: 0.3, alpha: 0.85),
                CGColor(red: 1.0, green: 0.5, blue: 0.1, alpha: 0.0)
            ] as CFArray, locations: [0, 1])!
            ctx.drawRadialGradient(flameGlow, startCenter: CGPoint(x: candX, y: altarY + altarH + 190), startRadius: 4, endCenter: CGPoint(x: candX, y: altarY + altarH + 190), endRadius: 65, options: [])
            
            // Flame
            ctx.setFillColor(CGColor(red: 1.0, green: 0.65, blue: 0.1, alpha: 1.0))
            ctx.fillEllipse(in: CGRect(x: candX - 8, y: altarY + altarH + 172, width: 16, height: 32))
            ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.7, alpha: 1.0))
            ctx.fillEllipse(in: CGRect(x: candX - 4, y: altarY + altarH + 176, width: 8, height: 18))
        }
        
        // Lower Half: Polished Church Nave Floor Tiles & Red Carpet Aisle
        let floorGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.42, green: 0.34, blue: 0.26, alpha: 1.0),
            CGColor(red: 0.25, green: 0.18, blue: 0.12, alpha: 1.0)
        ] as CFArray, locations: [0.0, 1.0])!
        ctx.drawLinearGradient(floorGrad, start: CGPoint(x: 540, y: 760), end: CGPoint(x: 540, y: 0), options: [])
        
        // Red Carpet Aisle (Lối đi chính trải thảm đỏ nhung hoàng gia)
        let carpetPath = CGMutablePath()
        carpetPath.move(to: CGPoint(x: 540 - 150, y: 760))
        carpetPath.addLine(to: CGPoint(x: 540 - 240, y: 0))
        carpetPath.addLine(to: CGPoint(x: 540 + 240, y: 0))
        carpetPath.addLine(to: CGPoint(x: 540 + 150, y: 760))
        carpetPath.closeSubpath()
        
        ctx.saveGState()
        let carpetGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.68, green: 0.12, blue: 0.18, alpha: 1.0),
            CGColor(red: 0.45, green: 0.08, blue: 0.12, alpha: 1.0)
        ] as CFArray, locations: [0.0, 1.0])!
        ctx.addPath(carpetPath)
        ctx.clip()
        ctx.drawLinearGradient(carpetGrad, start: CGPoint(x: 540, y: 760), end: CGPoint(x: 540, y: 0), options: [])
        
        // Gold edge on carpet
        ctx.setStrokeColor(CGColor(red: 0.90, green: 0.75, blue: 0.25, alpha: 0.85))
        ctx.setLineWidth(6)
        ctx.addPath(carpetPath)
        ctx.strokePath()
        ctx.restoreGState()
        
        if let img = ctx.makeImage() {
            let nsImg = NSImage(cgImage: img, size: NSSize(width: targetW, height: targetH))
            if let tiff = nsImg.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
                if let jpg = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.94]) {
                    try? jpg.write(to: URL(fileURLWithPath: outDir + "church_altar.jpg"))
                    try? jpg.write(to: URL(fileURLWithPath: "/Users/minhmarcom/.gemini/antigravity/scratch/StudioLive/overlay/church-assets/church_altar.jpg"))
                    print("Generated stylized game art: church_altar.jpg")
                }
            }
        }
    }
    
    // --- 2. GAME ART: BELL TOWER & MARIAN SHRINE (game_tower.png) ---
    do {
        let ctx = CGContext(data: nil, width: Int(targetW), height: Int(targetH), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        // Peaceful anime / game blue sky gradient
        let skyGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.15, green: 0.45, blue: 0.88, alpha: 1.0),
            CGColor(red: 0.40, green: 0.68, blue: 0.96, alpha: 1.0),
            CGColor(red: 0.75, green: 0.88, blue: 0.98, alpha: 1.0)
        ] as CFArray, locations: [0.0, 0.6, 1.0])!
        ctx.drawLinearGradient(skyGrad, start: CGPoint(x: 540, y: targetH), end: CGPoint(x: 540, y: 800), options: [])
        
        // Stylized anime fluffy white clouds
        ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85))
        let cloudCenters: [(CGFloat, CGFloat, CGFloat)] = [
            (240, 1680, 120), (340, 1710, 150), (450, 1670, 110),
            (820, 1620, 130), (920, 1650, 160), (740, 1600, 100),
            (150, 1380, 90), (950, 1350, 110)
        ]
        for (cx, cy, r) in cloudCenters {
            ctx.fillEllipse(in: CGRect(x: cx - r, y: cy - r * 0.7, width: r * 2, height: r * 1.4))
        }
        
        // Church Bell Tower (Tháp Chuông Nhà Thờ) - Centered in upper half
        let towerX: CGFloat = 540
        let towerBaseW: CGFloat = 260
        let towerTopW: CGFloat = 190
        let towerY: CGFloat = 860
        let towerH: CGFloat = 680
        
        // Tower Body (Warm yellow-cream stucco)
        let towerPath = CGMutablePath()
        towerPath.move(to: CGPoint(x: towerX - towerBaseW/2, y: towerY))
        towerPath.addLine(to: CGPoint(x: towerX - towerTopW/2, y: towerY + towerH))
        towerPath.addLine(to: CGPoint(x: towerX + towerTopW/2, y: towerY + towerH))
        towerPath.addLine(to: CGPoint(x: towerX + towerBaseW/2, y: towerY))
        towerPath.closeSubpath()
        
        ctx.setFillColor(CGColor(red: 0.96, green: 0.88, blue: 0.65, alpha: 1.0))
        ctx.addPath(towerPath); ctx.fillPath()
        ctx.setStrokeColor(CGColor(red: 0.80, green: 0.68, blue: 0.45, alpha: 1.0))
        ctx.setLineWidth(6)
        ctx.addPath(towerPath); ctx.strokePath()
        
        // Belfry Windows with Golden Bells
        for i in 0..<3 {
            let winY = towerY + 120 + CGFloat(i) * 160
            let winW: CGFloat = 70
            let winH: CGFloat = 110
            
            // Louver / Arch window
            let winPath = CGMutablePath()
            winPath.move(to: CGPoint(x: towerX - winW/2, y: winY))
            winPath.addLine(to: CGPoint(x: towerX - winW/2, y: winY + winH - 30))
            winPath.addQuadCurve(to: CGPoint(x: towerX + winW/2, y: winY + winH - 30), control: CGPoint(x: towerX, y: winY + winH + 15))
            winPath.addLine(to: CGPoint(x: towerX + winW/2, y: winY))
            winPath.closeSubpath()
            
            ctx.setFillColor(CGColor(red: 0.25, green: 0.18, blue: 0.12, alpha: 0.85))
            ctx.addPath(winPath); ctx.fillPath()
            
            // Bell in window
            ctx.setFillColor(CGColor(red: 0.95, green: 0.80, blue: 0.25, alpha: 1.0))
            ctx.fillEllipse(in: CGRect(x: towerX - 18, y: winY + 25, width: 36, height: 42))
        }
        
        // Steeple / Red Tiled Roof (Mái tháp ngói đỏ vươn cao)
        let roofPath = CGMutablePath()
        roofPath.move(to: CGPoint(x: towerX - towerTopW/2 - 20, y: towerY + towerH))
        roofPath.addLine(to: CGPoint(x: towerX, y: towerY + towerH + 280))
        roofPath.addLine(to: CGPoint(x: towerX + towerTopW/2 + 20, y: towerY + towerH))
        roofPath.closeSubpath()
        
        ctx.setFillColor(CGColor(red: 0.82, green: 0.25, blue: 0.20, alpha: 1.0))
        ctx.addPath(roofPath); ctx.fillPath()
        ctx.setStrokeColor(CGColor(red: 0.55, green: 0.12, blue: 0.08, alpha: 1.0))
        ctx.setLineWidth(5)
        ctx.addPath(roofPath); ctx.strokePath()
        
        // White Christian Cross on Steeple Pinnacle
        let crossPinnacleY = towerY + towerH + 280
        ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
        ctx.setStrokeColor(CGColor(red: 0.80, green: 0.85, blue: 0.95, alpha: 1.0))
        ctx.setLineWidth(3)
        let pVert = CGRect(x: towerX - 10, y: crossPinnacleY, width: 20, height: 110)
        let pHoriz = CGRect(x: towerX - 40, y: crossPinnacleY + 50, width: 80, height: 20)
        ctx.fill(pVert); ctx.stroke(pVert)
        ctx.fill(pHoriz); ctx.stroke(pHoriz)
        
        // Church building wings on left and right
        ctx.setFillColor(CGColor(red: 0.92, green: 0.82, blue: 0.60, alpha: 1.0))
        ctx.fill(CGRect(x: 40, y: 780, width: 380, height: 200))
        ctx.fill(CGRect(x: 660, y: 780, width: 380, height: 200))
        // Roofs on wings
        ctx.setFillColor(CGColor(red: 0.78, green: 0.22, blue: 0.18, alpha: 1.0))
        ctx.fill(CGRect(x: 30, y: 980, width: 400, height: 35))
        ctx.fill(CGRect(x: 650, y: 980, width: 400, height: 35))
        
        // Ground: Stylized stone courtyard plaza (Sân gạch nhà thờ)
        let plazaGrad = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 0.85, green: 0.80, blue: 0.70, alpha: 1.0),
            CGColor(red: 0.68, green: 0.62, blue: 0.52, alpha: 1.0)
        ] as CFArray, locations: [0.0, 1.0])!
        ctx.drawLinearGradient(plazaGrad, start: CGPoint(x: 540, y: 800), end: CGPoint(x: 540, y: 0), options: [])
        
        // Central Stone Walkway (Lối đi đá dẫn vào đài Đức Mẹ)
        let walkPath = CGMutablePath()
        walkPath.move(to: CGPoint(x: 540 - 130, y: 780))
        walkPath.addLine(to: CGPoint(x: 540 - 240, y: 0))
        walkPath.addLine(to: CGPoint(x: 540 + 240, y: 0))
        walkPath.addLine(to: CGPoint(x: 540 + 130, y: 780))
        walkPath.closeSubpath()
        ctx.setFillColor(CGColor(red: 0.92, green: 0.88, blue: 0.80, alpha: 1.0))
        ctx.addPath(walkPath); ctx.fillPath()
        
        // Stylized Ornamental Trees & Shrubs on left and right
        let bushColors = [
            CGColor(red: 0.20, green: 0.58, blue: 0.28, alpha: 1.0),
            CGColor(red: 0.14, green: 0.48, blue: 0.22, alpha: 1.0),
            CGColor(red: 0.26, green: 0.68, blue: 0.35, alpha: 1.0)
        ]
        for bx in [140, 260, 370, 710, 820, 940] {
            let bX = CGFloat(bx)
            ctx.setFillColor(bushColors[bx % 3])
            ctx.fillEllipse(in: CGRect(x: bX - 55, y: 720, width: 110, height: 160))
            // Flower pots
            ctx.setFillColor(CGColor(red: 0.72, green: 0.30, blue: 0.20, alpha: 1.0))
            ctx.fill(CGRect(x: bX - 35, y: 680, width: 70, height: 45))
        }
        
        // Central Marian Shrine Pedestal (Bệ đài Đức Mẹ bằng đá hoa cương đỏ)
        let pedW: CGFloat = 200
        let pedH: CGFloat = 220
        let pedY: CGFloat = 720
        
        ctx.setFillColor(CGColor(red: 0.45, green: 0.15, blue: 0.12, alpha: 1.0))
        ctx.fill(CGRect(x: 540 - pedW/2, y: pedY, width: pedW, height: pedH))
        ctx.setStrokeColor(CGColor(red: 0.75, green: 0.35, blue: 0.25, alpha: 1.0))
        ctx.setLineWidth(6)
        ctx.stroke(CGRect(x: 540 - pedW/2, y: pedY, width: pedW, height: pedH))
        
        // Base moldings
        ctx.fill(CGRect(x: 540 - pedW/2 - 25, y: pedY, width: pedW + 50, height: 35))
        ctx.fill(CGRect(x: 540 - pedW/2 - 15, y: pedY + pedH - 30, width: pedW + 30, height: 30))
        
        // Serene Pure White Statue of Our Lady with Baby Jesus (Tượng Đức Mẹ bồng Chúa Hài Đồng)
        let statY = pedY + pedH
        
        // Golden divine aura around Mary
        let maryGlow = CGGradient(colorsSpace: colorSpace, colors: [
            CGColor(red: 1.0, green: 0.95, blue: 0.75, alpha: 0.8),
            CGColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 0.0)
        ] as CFArray, locations: [0, 1])!
        ctx.drawRadialGradient(maryGlow, startCenter: CGPoint(x: 540, y: statY + 180), startRadius: 20, endCenter: CGPoint(x: 540, y: statY + 180), endRadius: 240, options: [])
        
        // White marble statue figure
        ctx.setFillColor(CGColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0))
        ctx.setStrokeColor(CGColor(red: 0.82, green: 0.86, blue: 0.94, alpha: 1.0))
        ctx.setLineWidth(3)
        
        // Flowing mantle & dress
        let mantlePath = CGMutablePath()
        mantlePath.move(to: CGPoint(x: 540 - 25, y: statY + 280)) // crown/head
        mantlePath.addQuadCurve(to: CGPoint(x: 540 - 80, y: statY + 100), control: CGPoint(x: 540 - 75, y: statY + 220))
        mantlePath.addQuadCurve(to: CGPoint(x: 540 - 70, y: statY), control: CGPoint(x: 540 - 85, y: statY + 40))
        mantlePath.addLine(to: CGPoint(x: 540 + 70, y: statY))
        mantlePath.addQuadCurve(to: CGPoint(x: 540 + 80, y: statY + 100), control: CGPoint(x: 540 + 85, y: statY + 40))
        mantlePath.addQuadCurve(to: CGPoint(x: 540 + 25, y: statY + 280), control: CGPoint(x: 540 + 75, y: statY + 220))
        mantlePath.closeSubpath()
        
        ctx.addPath(mantlePath); ctx.fillPath(); ctx.strokePath()
        
        // Baby Jesus in arms
        ctx.fillEllipse(in: CGRect(x: 540 - 55, y: statY + 150, width: 36, height: 42)) // Jesus head
        ctx.fill(CGRect(x: 540 - 62, y: statY + 100, width: 44, height: 60)) // Jesus body
        
        // Mary head & crown
        ctx.fillEllipse(in: CGRect(x: 540 - 22, y: statY + 260, width: 44, height: 50))
        // Crown of stars (Vương miện vàng)
        ctx.setFillColor(CGColor(red: 0.98, green: 0.85, blue: 0.25, alpha: 1.0))
        ctx.fill(CGRect(x: 540 - 18, y: statY + 310, width: 36, height: 16))
        
        if let img = ctx.makeImage() {
            let nsImg = NSImage(cgImage: img, size: NSSize(width: targetW, height: targetH))
            if let tiff = nsImg.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
                if let jpg = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.94]) {
                    try? jpg.write(to: URL(fileURLWithPath: outDir + "church_tower.jpg"))
                    try? jpg.write(to: URL(fileURLWithPath: "/Users/minhmarcom/.gemini/antigravity/scratch/StudioLive/overlay/church-assets/church_tower.jpg"))
                    print("Generated stylized game art: church_tower.jpg")
                }
            }
        }
    }
}

generateVectorGameBackgrounds()
