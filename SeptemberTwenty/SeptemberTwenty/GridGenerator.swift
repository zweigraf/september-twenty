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
    static var gridLineColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    static var gridTextFontSize = UIFont.smallSystemFontSize()
    static var gridTextLeftOffset = CGFloat(50)
    static var gridTextBottomOffset = CGFloat(50)
    
    static func createGrid(frame: CGRect, step: CGFloat) ->  SKNode {
        let minX = CGRectGetMinX(frame)
        let maxX = CGRectGetMaxX(frame)
        let midX = CGRectGetMidX(frame)
        let minY = CGRectGetMinY(frame)
        let maxY = CGRectGetMaxY(frame)
        let midY = CGRectGetMidY(frame)
        
        let grid = SKNode()
        
        for var x = minX; x < maxX + step; x += step {
            x = min(x, maxX)
            let y = midY
            
            let node = SKSpriteNode(color: gridLineColor, size: CGSize(width: gridLineWidth, height: Int(CGRectGetHeight(frame))))
            node.position = CGPoint(x: x, y: y)
            grid.addChild(node)
            
            let label = createLabel("\(Int(x))")
            label.position = CGPoint(x: x, y: minY - gridTextBottomOffset)
            grid.addChild(label)
        }
        
        for var y = minY; y < maxY + step; y += step {
            y = min(y, maxY)
            let x = midX
            
            let node = SKSpriteNode(color: gridLineColor, size: CGSize(width: Int(CGRectGetWidth(frame)), height: gridLineWidth))
            node.position = CGPoint(x: x, y: y)
            grid.addChild(node)
            
            let label = createLabel("\(Int(y))")
            label.position = CGPoint(x: minX - gridTextLeftOffset, y: y)
            grid.addChild(label)
        }
        
        return grid
    }
    
    private static func createLabel(text: String) -> SKNode {
        let label = SKLabelNode(text: text)
        label.fontColor = gridLineColor
        label.fontSize = gridTextFontSize
        return label
    }
}
