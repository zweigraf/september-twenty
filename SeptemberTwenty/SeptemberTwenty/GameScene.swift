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
    let BlockColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
    
    let PaddleSize = CGSize(width: 200, height: 50)
    let BlockSize = CGSize(width: 100, height: 50)
    
    let PaddleBottomOffset = 50
    let BlockTopOffset = 68
    let BlockLeftOffset : CGFloat = 50
    let BlockRightOffset : CGFloat = 50
    let BlockRowCount = 4
    
    let PaddleName = "paddle"
    let BlockName = "block"
    
    weak var paddle : SKNode?
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        addGrid()
        
        addPaddle()
        addBlocks()
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
    
    func addBlocks() {
        let space = self.frame.size.width - BlockLeftOffset - BlockRightOffset
        
        let numberOfBlocksInRow = Int(space / BlockSize.width)
        let widthOfRow = CGFloat(numberOfBlocksInRow) * BlockSize.width
        let xOfFirstBlock = self.frame.origin.x + BlockLeftOffset + ((space - widthOfRow) / 2) + (BlockSize.width / 2)
        let xOfLastBlock = xOfFirstBlock + (CGFloat(numberOfBlocksInRow - 1) * BlockSize.width)
        
        let yOfFirstBlock = CGRectGetMaxY(self.frame) - CGFloat(BlockTopOffset) - (BlockSize.height / 2)
        let yOfLastBlock = yOfFirstBlock - (CGFloat(BlockRowCount - 1) * BlockSize.height)
        
        for var y = yOfFirstBlock; y >= yOfLastBlock; y -= BlockSize.height {
            for var x = xOfFirstBlock; x <= xOfLastBlock; x += BlockSize.width {
                let block = SKSpriteNode(color: BlockColor, size: BlockSize)
                block.position = CGPoint(x: x, y: y)
                block.name = BlockName;
                addChild(block)
            }
        }
    }
    
    func setPaddlePosition(x:CGFloat) {
        paddle?.position.x = x
    }
}
