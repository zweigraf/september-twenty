//
//  GameScene.swift
//  SeptemberTwenty
//
//  Created by Luis Reisewitz on 20.09.15.
//  Copyright (c) 2015 ZweiGraf. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let PaddleColor = UIColor.redColor().colorWithAlphaComponent(0.5)
    let PaddleSize = CGSize(width: 200, height: 50)
    let PaddleBottomOffset = 50
    
    let PaddleName = "paddle"
    
    weak var paddle : SKNode?
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        addGrid()
        
        addPaddle()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            setPaddlePosition(location.x)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            setPaddlePosition(location.x)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addGrid() {
        let grid = GridGenerator.createGrid(self.frame, step: 50)
        grid.zPosition = -1
        addChild(grid)
    }
    
    func addPaddle() {
        let paddle = SKSpriteNode(color: PaddleColor, size: PaddleSize)
        paddle.position = CGPoint(x: Int(CGRectGetMidX(self.frame)), y: PaddleBottomOffset)
        addChild(paddle)
        self.paddle = paddle
    }
    
    func setPaddlePosition(x:CGFloat) {
        paddle?.position.x = x
    }
}
