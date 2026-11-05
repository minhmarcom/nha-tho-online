import Foundation
import CoreGraphics
import AppKit

func createVerticalChurchImages() {
    let assetsDir = "/Users/minhmarcom/.gemini/antigravity/scratch/StudioLive/overlay/church-assets/"
    let targetW: CGFloat = 1080
    let targetH: CGFloat = 1920
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    // --- 1. COMPOSE TOWER & MARY (church_tower.jpg) ---
    if let towerImg = NSImage(contentsOfFile: assetsDir + "tower_mary.jpg") {
        guard let context = CGContext(data: nil, width: Int(targetW), height: Int(targetH), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            print("Failed to create context for tower")
            return
        }
        
        let towerCG = towerImg.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        
        // Sky color gradient at top
        let skyTop = CGColor(red: 0.15, green: 0.45, blue: 0.85, alpha: 1.0)
        let skyBottom = CGColor(red: 0.40, green: 0.65, blue: 0.95, alpha: 1.0)
        let gradient = CGGradient(colorsSpace: colorSpace, colors: [skyTop, skyBottom] as CFArray, locations: [0.0, 1.0])!
        
        // Draw sky
        context.drawLinearGradient(gradient, start: CGPoint(x: targetW/2, y: targetH), end: CGPoint(x: targetW/2, y: 0), options: [])
        
        // Position tower so cross is near y = 1450 (in CG coordinates, 0 is bottom),
        // meaning near the upper-third of screen
        let origW = CGFloat(towerCG.width)
        let origH = CGFloat(towerCG.height)
        
        // Scale to fill width
        let scale = targetW / origW
        let drawW = targetW
        let drawH = origH * scale
        
        // In CGContext, (0,0) is bottom-left.
        // We want the statue and tower centered, and lower walkway at bottom.
        let drawY: CGFloat = 180
        
        context.draw(towerCG, in: CGRect(x: 0, y: drawY, width: drawW, height: drawH))
        
        // Fill walkway at bottom (extend lower paving stones)
        let walkSliceH: CGFloat = 40
        if let walkSlice = towerCG.cropping(to: CGRect(x: 0, y: 0, width: origW, height: walkSliceH)) {
            context.draw(walkSlice, in: CGRect(x: 0, y: 0, width: targetW, height: drawY + 10))
        }
        
        // Add smooth sky blend at the very top if tower image ended before top
        if drawY + drawH < targetH {
            let skySliceH: CGFloat = 30
            if let skySlice = towerCG.cropping(to: CGRect(x: 0, y: origH - skySliceH, width: origW, height: skySliceH)) {
                context.draw(skySlice, in: CGRect(x: 0, y: drawY + drawH - 5, width: targetW, height: targetH - (drawY + drawH) + 10))
            }
        }
        
        if let outImg = context.makeImage() {
            let nsOut = NSImage(cgImage: outImg, size: NSSize(width: targetW, height: targetH))
            if let tiff = nsOut.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
                let jpgData = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.92])
                try? jpgData?.write(to: URL(fileURLWithPath: assetsDir + "church_tower.jpg"))
                print("Created church_tower.jpg successfully!")
            }
        }
    }
    
    // --- 2. COMPOSE ALTAR & SANCTUARY (church_altar.jpg) ---
    if let altarImg = NSImage(contentsOfFile: assetsDir + "altar_mass.jpg") {
        guard let context = CGContext(data: nil, width: Int(targetW), height: Int(targetH), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            print("Failed to create context for altar")
            return
        }
        
        let altarCG = altarImg.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        
        // Warm church interior background tone (soft cream / warm beige)
        let wallTop = CGColor(red: 0.96, green: 0.94, blue: 0.85, alpha: 1.0)
        let wallBottom = CGColor(red: 0.90, green: 0.86, blue: 0.74, alpha: 1.0)
        let wallGrad = CGGradient(colorsSpace: colorSpace, colors: [wallTop, wallBottom] as CFArray, locations: [0.0, 1.0])!
        context.drawLinearGradient(wallGrad, start: CGPoint(x: targetW/2, y: targetH), end: CGPoint(x: targetW/2, y: 0), options: [])
        
        let origW = CGFloat(altarCG.width)
        let origH = CGFloat(altarCG.height)
        
        // Scale altar to 1080 width
        let scale = targetW / origW
        let drawW = targetW
        let drawH = origH * scale
        
        // Place Altar in upper-middle so Cross is prominently displayed
        // CGContext y=0 is bottom. We want altar floor around y=750 (meaning 1170px from top)
        let drawY: CGFloat = 720
        context.draw(altarCG, in: CGRect(x: 0, y: drawY, width: drawW, height: drawH))
        
        // Extend top arch wall
        let topWallH: CGFloat = 30
        if let wallSlice = altarCG.cropping(to: CGRect(x: 0, y: origH - topWallH, width: origW, height: topWallH)) {
            context.draw(wallSlice, in: CGRect(x: 0, y: drawY + drawH - 5, width: targetW, height: targetH - (drawY + drawH) + 10))
        }
        
        // Lower half: Floor tiles and wooden pews!
        // Floor tile color
        let floorColor1 = CGColor(red: 0.88, green: 0.84, blue: 0.73, alpha: 1.0)
        let floorColor2 = CGColor(red: 0.78, green: 0.72, blue: 0.60, alpha: 1.0)
        let floorGrad = CGGradient(colorsSpace: colorSpace, colors: [floorColor1, floorColor2] as CFArray, locations: [0.0, 1.0])!
        context.drawLinearGradient(floorGrad, start: CGPoint(x: targetW/2, y: drawY + 10), end: CGPoint(x: targetW/2, y: 0), options: [])
        
        // If procession image is available, composite wooden church pews on sides
        if let procImg = NSImage(contentsOfFile: assetsDir + "procession_pews.jpg") {
            let procCG = procImg.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            // Crop lower right wooden pew from procession image
            let pW = CGFloat(procCG.width)
            let pH = CGFloat(procCG.height)
            let pewCrop = CGRect(x: pW * 0.72, y: 0, width: pW * 0.28, height: pH * 0.45)
            if let pewSlice = procCG.cropping(to: pewCrop) {
                // Draw pews on right
                context.draw(pewSlice, in: CGRect(x: targetW - 280, y: 40, width: 280, height: 420))
            }
        }
        
        if let outImg = context.makeImage() {
            let nsOut = NSImage(cgImage: outImg, size: NSSize(width: targetW, height: targetH))
            if let tiff = nsOut.tiffRepresentation, let rep = NSBitmapImageRep(data: tiff) {
                let jpgData = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.92])
                try? jpgData?.write(to: URL(fileURLWithPath: assetsDir + "church_altar.jpg"))
                print("Created church_altar.jpg successfully!")
            }
        }
    }
}

createVerticalChurchImages()
