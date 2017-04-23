//
//  GridGenerator.swift
//  SeptemberTwenty
//
//  Created by Luis Reisewitz on 20.09.15.
//  Copyright © 2015 ZweiGraf. All rights reserved.
//

import SpriteKit

class GridGenerator: NSObject {
    static var gridLineWidth = 2
    static var gridLineColor = UIColor.black.withAlphaComponent(0.5)
    static var gridTextFontSize = UIFont.smallSystemFontSize
    static var gridTextLeftOffset = CGFloat(50)
    static var gridTextBottomOffset = CGFloat(50)
    
    static func createGrid(_ frame: CGRect, step: CGFloat) ->  SKNode {
        let minX = frame.minX
        let maxX = frame.maxX
        let midX = frame.midX
        let minY = frame.minY
        let maxY = frame.maxY
        let midY = frame.midY
        
        let grid = SKNode()
        
        var x = minX
        while x < maxX {
            x = min(x, maxX)
            let y = midY
            
            let node = SKSpriteNode(color: gridLineColor, size: CGSize(width: gridLineWidth, height: Int(frame.height)))
            node.position = CGPoint(x: x, y: y)
            grid.addChild(node)
            
            let label = createLabel("\(Int(x))")
            label.position = CGPoint(x: x, y: minY - gridTextBottomOffset)
            grid.addChild(label)
            
            x += step
        }
        
        var y = minY
        while y < maxY + step {
            y = min(y, maxY)
            let x = midX
            
            let node = SKSpriteNode(color: gridLineColor, size: CGSize(width: Int(frame.width), height: gridLineWidth))
            node.position = CGPoint(x: x, y: y)
            grid.addChild(node)
            
            let label = createLabel("\(Int(y))")
            label.position = CGPoint(x: minX - gridTextLeftOffset, y: y)
            grid.addChild(label)
            
            y += step
        }
        
        return grid
    }
    
    fileprivate static func createLabel(_ text: String) -> SKNode {
        let label = SKLabelNode(text: text)
        label.fontColor = gridLineColor
        label.fontSize = gridTextFontSize
        return label
    }
}
