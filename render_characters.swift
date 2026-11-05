import Foundation
import CoreGraphics
import AppKit

func savePNG(image: CGImage, path: String) {
    let url = URL(fileURLWithPath: path)
    let nsImage = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
    if let tiff = nsImage.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
        if let png = rep.representation(using: .png, properties: [:]) {
            try? png.write(to: url)
            print("Rendered Catholic Character: \(path)")
        }
    }
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
let assetDirs = [
    "/Users/minhmarcom/.gemini/antigravity/scratch/NhaThoOnline/assets/",
    "/Users/minhmarcom/.gemini/antigravity/scratch/StudioLive/overlay/church-assets/"
]

let W = 212
let H = 300
let cx = CGFloat(W) / 2

func makeCtx() -> CGContext {
    return CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
}

func deploy(img: CGImage, filename: String) {
    for dir in assetDirs {
        savePNG(image: img, path: dir + filename)
    }
}

// ========================================================
// 1. LINH MỤC (c_priest.png) - Red Liturgical Chasuble & White Alb
// ========================================================
do {
    let ctx = makeCtx()
    
    // Shoes (Black polished)
    ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 35, y: 4, width: 30, height: 16))
    ctx.fillEllipse(in: CGRect(x: cx + 5, y: 4, width: 30, height: 16))
    
    // White Alb (Áo Alba chùng trắng dài chấm gót)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    let alb = CGMutablePath()
    alb.move(to: CGPoint(x: cx - 22, y: 228))
    alb.addLine(to: CGPoint(x: cx - 55, y: 12))
    alb.addLine(to: CGPoint(x: cx + 55, y: 12))
    alb.addLine(to: CGPoint(x: cx + 22, y: 228))
    alb.closeSubpath()
    ctx.addPath(alb); ctx.fillPath()
    
    // Red Liturgical Chasuble (Áo Lễ Đỏ hình oval phủ ngoài)
    let chasuble = CGMutablePath()
    chasuble.move(to: CGPoint(x: cx - 24, y: 226))
    chasuble.addQuadCurve(to: CGPoint(x: cx - 85, y: 140), control: CGPoint(x: cx - 75, y: 215)) // left shoulder
    chasuble.addQuadCurve(to: CGPoint(x: cx, y: 35), control: CGPoint(x: cx - 80, y: 65))       // bottom center curved hem
    chasuble.addQuadCurve(to: CGPoint(x: cx + 85, y: 140), control: CGPoint(x: cx + 80, y: 65)) // right shoulder
    chasuble.addQuadCurve(to: CGPoint(x: cx + 24, y: 226), control: CGPoint(x: cx + 75, y: 215))
    chasuble.closeSubpath()
    
    ctx.setFillColor(CGColor(red: 0.85, green: 0.12, blue: 0.16, alpha: 1.0)) // liturgical red
    ctx.addPath(chasuble); ctx.fillPath()
    
    // Golden border trim around Chasuble
    ctx.setStrokeColor(CGColor(red: 0.98, green: 0.82, blue: 0.25, alpha: 1.0))
    ctx.setLineWidth(4)
    ctx.addPath(chasuble); ctx.strokePath()
    
    // Golden Orphrey Cross on Chasuble (Thánh Giá thêu chỉ vàng phụng vụ)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.82, blue: 0.25, alpha: 1.0))
    let vertOrphrey = CGRect(x: cx - 12, y: 45, width: 24, height: 175)
    let horizOrphrey = CGRect(x: cx - 44, y: 155, width: 88, height: 22)
    ctx.fill(vertOrphrey); ctx.fill(horizOrphrey)
    // Center IHS emblem on cross
    ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.70, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 15, y: 152, width: 30, height: 28))
    
    // Hands folded in prayer (Chắp tay trước ngực)
    ctx.setFillColor(CGColor(red: 0.95, green: 0.78, blue: 0.65, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 125, width: 36, height: 26))
    
    // Clerical Collar (Cổ áo giáo sĩ màu đen với thẻ trắng La Mã ở giữa)
    ctx.setFillColor(CGColor(red: 0.12, green: 0.12, blue: 0.15, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 22, y: 222, width: 44, height: 14))
    ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 6, y: 224, width: 12, height: 10))
    
    // Priest Head & Kind Face (Khuôn mặt phúc hậu)
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 24, y: 228, width: 48, height: 56))
    // Hair (Neat black hair)
    ctx.setFillColor(CGColor(red: 0.20, green: 0.18, blue: 0.16, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 26, y: 262, width: 52, height: 28))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_priest.png") }
}

// ========================================================
// 2. LỄ SINH / GIÚP LỄ (c_altar_server.png) - Red Cassock & White Surplice with Processional Candle
// ========================================================
do {
    let ctx = makeCtx()
    
    // Shoes
    ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 30, y: 4, width: 26, height: 14))
    ctx.fillEllipse(in: CGRect(x: cx + 4, y: 4, width: 26, height: 14))
    
    // Red Cassock (Áo chùng đỏ của lễ sinh)
    ctx.setFillColor(CGColor(red: 0.80, green: 0.12, blue: 0.15, alpha: 1.0))
    let cassock = CGMutablePath()
    cassock.move(to: CGPoint(x: cx - 20, y: 220))
    cassock.addLine(to: CGPoint(x: cx - 50, y: 10))
    cassock.addLine(to: CGPoint(x: cx + 50, y: 10))
    cassock.addLine(to: CGPoint(x: cx + 20, y: 220))
    cassock.closeSubpath()
    ctx.addPath(cassock); ctx.fillPath()
    
    // White Surplice / Cotta (Áo trắng phủ ngang hông với tay áo rộng và viền ren)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    ctx.setStrokeColor(CGColor(red: 0.88, green: 0.90, blue: 0.95, alpha: 1.0))
    ctx.setLineWidth(2)
    
    let surplice = CGMutablePath()
    surplice.move(to: CGPoint(x: cx - 22, y: 222))
    surplice.addLine(to: CGPoint(x: cx - 62, y: 145)) // wide sleeve
    surplice.addLine(to: CGPoint(x: cx - 54, y: 95))  // waist hem
    surplice.addLine(to: CGPoint(x: cx + 54, y: 95))
    surplice.addLine(to: CGPoint(x: cx + 62, y: 145))
    surplice.addLine(to: CGPoint(x: cx + 22, y: 222))
    surplice.closeSubpath()
    ctx.addPath(surplice); ctx.drawPath(using: .fillStroke)
    
    // Red Mozzetta / Yoke collar (Cổ viền đỏ phụng vụ)
    ctx.setFillColor(CGColor(red: 0.80, green: 0.12, blue: 0.15, alpha: 1.0))
    let collar = CGMutablePath()
    collar.move(to: CGPoint(x: cx - 20, y: 222))
    collar.addQuadCurve(to: CGPoint(x: cx, y: 178), control: CGPoint(x: cx - 25, y: 190))
    collar.addQuadCurve(to: CGPoint(x: cx + 20, y: 222), control: CGPoint(x: cx + 25, y: 190))
    collar.closeSubpath()
    ctx.addPath(collar); ctx.fillPath()
    
    // Hands holding tall brass processional candlestick
    ctx.setFillColor(CGColor(red: 0.95, green: 0.78, blue: 0.65, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 14, y: 120, width: 28, height: 22))
    
    // Brass pole (Cán nến đồng vàng cao)
    ctx.setFillColor(CGColor(red: 0.88, green: 0.72, blue: 0.22, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 3, y: 25, width: 6, height: 185))
    ctx.fill(CGRect(x: cx - 14, y: 205, width: 28, height: 10)) // candle cup
    
    // Candle wax & glowing flame
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 0.95, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 6, y: 215, width: 12, height: 35))
    // Flame
    ctx.setFillColor(CGColor(red: 1.0, green: 0.65, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 6, y: 250, width: 12, height: 22))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.75, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 3, y: 253, width: 6, height: 12))
    
    // Head & Young boy face
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 225, width: 40, height: 46))
    ctx.setFillColor(CGColor(red: 0.18, green: 0.14, blue: 0.12, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 22, y: 252, width: 44, height: 24))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_altar_server.png") }
}

// ========================================================
// 3. NỮ TU / DÌ PHƯỚC / SƠ (c_nun.png) - Grey/Black Habit, Veil & Silver Cross
// ========================================================
do {
    let ctx = makeCtx()
    
    // Black shoes
    ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 30, y: 4, width: 26, height: 14))
    ctx.fillEllipse(in: CGRect(x: cx + 4, y: 4, width: 26, height: 14))
    
    // Religious Habit (Áo dòng xám tro thanh nhã)
    ctx.setFillColor(CGColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1.0))
    let habit = CGMutablePath()
    habit.move(to: CGPoint(x: cx - 20, y: 220))
    habit.addLine(to: CGPoint(x: cx - 50, y: 12))
    habit.addLine(to: CGPoint(x: cx + 50, y: 12))
    habit.addLine(to: CGPoint(x: cx + 20, y: 220))
    habit.closeSubpath()
    ctx.addPath(habit); ctx.fillPath()
    
    // Black leather belt around waist
    ctx.setFillColor(CGColor(red: 0.15, green: 0.15, blue: 0.18, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 35, y: 110, width: 70, height: 8))
    
    // Hands folded reverently holding Rosary beads
    ctx.setFillColor(CGColor(red: 0.95, green: 0.80, blue: 0.70, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 16, y: 115, width: 32, height: 22))
    
    // Silver crucifix on chest chain (Thánh Giá bạc trên ngực)
    ctx.setStrokeColor(CGColor(red: 0.75, green: 0.80, blue: 0.88, alpha: 1.0))
    ctx.setLineWidth(2)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: cx - 14, y: 200))
    ctx.addLine(to: CGPoint(x: cx, y: 155))
    ctx.addLine(to: CGPoint(x: cx + 14, y: 200))
    ctx.strokePath()
    
    // Silver Cross
    ctx.setFillColor(CGColor(red: 0.88, green: 0.92, blue: 0.98, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 3, y: 142, width: 6, height: 20))
    ctx.fill(CGRect(x: cx - 8, y: 152, width: 16, height: 5))
    
    // Wimple / Coif (Khăn trắng ôm sát cổ và cằm)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    let wimple = CGMutablePath()
    wimple.move(to: CGPoint(x: cx - 20, y: 260))
    wimple.addQuadCurve(to: CGPoint(x: cx, y: 195), control: CGPoint(x: cx - 22, y: 215))
    wimple.addQuadCurve(to: CGPoint(x: cx + 20, y: 260), control: CGPoint(x: cx + 22, y: 215))
    wimple.closeSubpath()
    ctx.addPath(wimple); ctx.fillPath()
    
    // Face (Khuôn mặt thánh thiện, dịu hiền)
    ctx.setFillColor(CGColor(red: 0.96, green: 0.82, blue: 0.72, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 225, width: 36, height: 42))
    
    // Veil (Khăn lúp dòng đen/xám phủ qua vai)
    ctx.setFillColor(CGColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1.0))
    let veil = CGMutablePath()
    veil.move(to: CGPoint(x: cx - 25, y: 260))
    veil.addQuadCurve(to: CGPoint(x: cx, y: 285), control: CGPoint(x: cx, y: 288))
    veil.addQuadCurve(to: CGPoint(x: cx + 25, y: 260), control: CGPoint(x: cx, y: 288))
    veil.addLine(to: CGPoint(x: cx + 38, y: 185))
    veil.addLine(to: CGPoint(x: cx - 38, y: 185))
    veil.closeSubpath()
    ctx.addPath(veil); ctx.fillPath()
    
    // Crisp white headband on forehead
    ctx.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 18, y: 260, width: 36, height: 8))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_nun.png") }
}

// ========================================================
// 4. THIẾU NHI THÁNH THỂ (c_eucharist.png) - TNTT Scarf & Uniform
// ========================================================
do {
    let ctx = makeCtx()
    
    // Shoes & Socks
    ctx.setFillColor(CGColor(red: 0.12, green: 0.12, blue: 0.15, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 28, y: 4, width: 24, height: 14))
    ctx.fillEllipse(in: CGRect(x: cx + 4, y: 4, width: 24, height: 14))
    
    // Navy Blue Pants (Quần tây xanh đen TNTT)
    ctx.setFillColor(CGColor(red: 0.14, green: 0.18, blue: 0.26, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 26, y: 10, width: 22, height: 105))
    ctx.fill(CGRect(x: cx + 4, y: 10, width: 22, height: 105))
    // Belt
    ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 30, y: 112, width: 60, height: 8))
    
    // White Shirt (Áo sơ mi trắng TNTT)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    let shirt = CGMutablePath()
    shirt.move(to: CGPoint(x: cx - 18, y: 218))
    shirt.addLine(to: CGPoint(x: cx - 52, y: 155))
    shirt.addLine(to: CGPoint(x: cx - 36, y: 115))
    shirt.addLine(to: CGPoint(x: cx + 36, y: 115))
    shirt.addLine(to: CGPoint(x: cx + 52, y: 155))
    shirt.addLine(to: CGPoint(x: cx + 18, y: 218))
    shirt.closeSubpath()
    ctx.addPath(shirt); ctx.fillPath()
    
    // TNTT Badge on left pocket (Huy hiệu Phong trào Thiếu Nhi Thánh Thể)
    ctx.setFillColor(CGColor(red: 0.85, green: 0.15, blue: 0.18, alpha: 1.0))
    ctx.fill(CGRect(x: cx + 12, y: 165, width: 14, height: 16))
    ctx.setFillColor(CGColor(red: 1.0, green: 0.95, blue: 0.4, alpha: 1.0))
    ctx.fill(CGRect(x: cx + 17, y: 168, width: 4, height: 10))
    
    // Signature TNTT Scarf (Khăn quàng TNTT màu vàng viền đỏ ngành Nghĩa Sĩ)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.82, blue: 0.15, alpha: 1.0)) // Golden yellow
    let scarf = CGMutablePath()
    scarf.move(to: CGPoint(x: cx - 20, y: 218))
    scarf.addLine(to: CGPoint(x: cx, y: 148)) // scarf knot and tail
    scarf.addLine(to: CGPoint(x: cx + 20, y: 218))
    scarf.closeSubpath()
    ctx.addPath(scarf); ctx.fillPath()
    
    // Red border ribbon on scarf (Viền đỏ)
    ctx.setStrokeColor(CGColor(red: 0.85, green: 0.15, blue: 0.18, alpha: 1.0))
    ctx.setLineWidth(3)
    ctx.addPath(scarf); ctx.strokePath()
    
    // Head & Cheerful Face
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 220, width: 36, height: 44))
    ctx.setFillColor(CGColor(red: 0.18, green: 0.14, blue: 0.10, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 248, width: 40, height: 22))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_eucharist.png") }
}

// ========================================================
// 5. GIÁO DÂN NỮ (c_woman.png) - Traditional Vietnamese Áo Dài in Church
// ========================================================
do {
    let ctx = makeCtx()
    
    // Delicate white silk pants hem
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 35, y: 10, width: 28, height: 40))
    ctx.fill(CGRect(x: cx + 7, y: 10, width: 28, height: 40))
    
    // Áo Dài Silk Tunic (Pastel Sky Blue with soft flower highlights)
    let aodai = CGMutablePath()
    aodai.move(to: CGPoint(x: cx - 18, y: 222))
    aodai.addLine(to: CGPoint(x: cx - 44, y: 140))
    aodai.addQuadCurve(to: CGPoint(x: cx - 48, y: 25), control: CGPoint(x: cx - 50, y: 80))
    aodai.addLine(to: CGPoint(x: cx + 48, y: 25))
    aodai.addQuadCurve(to: CGPoint(x: cx + 44, y: 140), control: CGPoint(x: cx + 50, y: 80))
    aodai.addLine(to: CGPoint(x: cx + 18, y: 222))
    aodai.closeSubpath()
    
    ctx.setFillColor(CGColor(red: 0.40, green: 0.72, blue: 0.90, alpha: 1.0)) // pastel sky blue
    ctx.addPath(aodai); ctx.fillPath()
    
    // Collar (Cổ đứng truyền thống 2cm)
    ctx.setFillColor(CGColor(red: 0.35, green: 0.65, blue: 0.85, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 14, y: 220, width: 28, height: 10))
    
    // Hands folded in prayer holding a gentle crystal Rosary
    ctx.setFillColor(CGColor(red: 0.96, green: 0.82, blue: 0.72, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 15, y: 125, width: 30, height: 22))
    
    // Head & Elegant Vietnamese hair bun
    ctx.setFillColor(CGColor(red: 0.96, green: 0.82, blue: 0.72, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 225, width: 36, height: 42))
    ctx.setFillColor(CGColor(red: 0.15, green: 0.12, blue: 0.10, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 252, width: 40, height: 26))
    ctx.fillEllipse(in: CGRect(x: cx - 12, y: 270, width: 24, height: 20)) // hair bun
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_woman.png") }
}

// ========================================================
// 6. GIÁO DÂN NAM (c_man.png) - Respectful Church Dress Shirt & Trousers
// ========================================================
do {
    let ctx = makeCtx()
    
    // Leather shoes
    ctx.setFillColor(CGColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 32, y: 4, width: 28, height: 14))
    ctx.fillEllipse(in: CGRect(x: cx + 4, y: 4, width: 28, height: 14))
    
    // Charcoal Tailored Trousers (Quần âu sẫm màu)
    ctx.setFillColor(CGColor(red: 0.18, green: 0.20, blue: 0.24, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 30, y: 10, width: 25, height: 110))
    ctx.fill(CGRect(x: cx + 5, y: 10, width: 25, height: 110))
    // Leather belt
    ctx.setFillColor(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 32, y: 118, width: 64, height: 8))
    
    // Crisp White Button-up Shirt (Áo sơ mi trắng thanh lịch)
    ctx.setFillColor(CGColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0))
    let shirt = CGMutablePath()
    shirt.move(to: CGPoint(x: cx - 20, y: 224))
    shirt.addLine(to: CGPoint(x: cx - 55, y: 155))
    shirt.addLine(to: CGPoint(x: cx - 38, y: 122))
    shirt.addLine(to: CGPoint(x: cx + 38, y: 122))
    shirt.addLine(to: CGPoint(x: cx + 55, y: 155))
    shirt.addLine(to: CGPoint(x: cx + 20, y: 224))
    shirt.closeSubpath()
    ctx.addPath(shirt); ctx.fillPath()
    
    // Collar & Necktie (Caravat xanh navy)
    ctx.setFillColor(CGColor(red: 0.15, green: 0.25, blue: 0.50, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 5, y: 165, width: 10, height: 55))
    
    // Hands folded reverently at waist
    ctx.setFillColor(CGColor(red: 0.95, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 16, y: 128, width: 32, height: 22))
    
    // Head & Neat haircut
    ctx.setFillColor(CGColor(red: 0.96, green: 0.80, blue: 0.68, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 226, width: 40, height: 48))
    ctx.setFillColor(CGColor(red: 0.18, green: 0.15, blue: 0.12, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 22, y: 254, width: 44, height: 26))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_man.png") }
}

// ========================================================
// 7. BÀ CỐ / BÁC LỚN TUỔI (c_granny.png) - Velvet Áo Dài with Wooden Rosary
// ========================================================
do {
    let ctx = makeCtx()
    
    // Black silk trousers
    ctx.setFillColor(CGColor(red: 0.15, green: 0.15, blue: 0.18, alpha: 1.0))
    ctx.fill(CGRect(x: cx - 35, y: 8, width: 30, height: 35))
    ctx.fill(CGRect(x: cx + 5, y: 8, width: 30, height: 35))
    
    // Maroon Velvet Áo Dài (Áo dài nhung đỏ mận truyền thống)
    let aodai = CGMutablePath()
    aodai.move(to: CGPoint(x: cx - 18, y: 218))
    aodai.addLine(to: CGPoint(x: cx - 44, y: 135))
    aodai.addQuadCurve(to: CGPoint(x: cx - 46, y: 20), control: CGPoint(x: cx - 48, y: 75))
    aodai.addLine(to: CGPoint(x: cx + 46, y: 20))
    aodai.addQuadCurve(to: CGPoint(x: cx + 44, y: 135), control: CGPoint(x: cx + 48, y: 75))
    aodai.addLine(to: CGPoint(x: cx + 18, y: 218))
    aodai.closeSubpath()
    
    ctx.setFillColor(CGColor(red: 0.45, green: 0.12, blue: 0.18, alpha: 1.0)) // maroon velvet
    ctx.addPath(aodai); ctx.fillPath()
    
    // Wooden Holy Rosary clasped in hands (Chuỗi hạt Mân Côi gỗ)
    ctx.setFillColor(CGColor(red: 0.95, green: 0.80, blue: 0.70, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 16, y: 120, width: 32, height: 22))
    
    // Wooden beads loop
    ctx.setStrokeColor(CGColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 1.0))
    ctx.setLineWidth(2.5)
    ctx.strokeEllipse(in: CGRect(x: cx - 12, y: 105, width: 24, height: 30))
    
    // Head & Silver-streaked hair bun (Búi tóc điểm hoa râm)
    ctx.setFillColor(CGColor(red: 0.95, green: 0.80, blue: 0.70, alpha: 1.0))
    ctx.fillEllipse(in: CGRect(x: cx - 18, y: 220, width: 36, height: 42))
    ctx.setFillColor(CGColor(red: 0.45, green: 0.45, blue: 0.48, alpha: 1.0)) // salt & pepper hair
    ctx.fillEllipse(in: CGRect(x: cx - 20, y: 246, width: 40, height: 24))
    ctx.fillEllipse(in: CGRect(x: cx - 12, y: 262, width: 24, height: 18))
    
    if let img = ctx.makeImage() { deploy(img: img, filename: "c_granny.png") }
}

print("ALL 7 CATHOLIC LITURGICAL & CULTURAL CHARACTER MODELS CREATED ACCURATELY!")
