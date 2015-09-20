//
//  GameScene.swift
//  SeptemberTwenty
//
//  Created by Luis Reisewitz on 20.09.15.
//  Copyright (c) 2015 ZweiGraf. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let PaddleColor = UIColor.redColor().colorWithAlphaComponent(0.5)
    let BlockColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
    let BallColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    
    let PaddleSize = CGSize(width: 200, height: 50)
    let BlockSize = CGSize(width: 100, height: 50)
    let BallSize = CGSize(width: 25, height: 25)
    
    let PaddleBottomOffset = 50
    let BlockTopOffset = 68
    let BlockLeftOffset : CGFloat = 50
    let BlockRightOffset : CGFloat = 50
    let BlockRowCount = 4
    let BallPaddleOffset = 50
    
    let BallStartVelocity = CGVector(dx: 0, dy: 100)
    
    let PaddleName = "paddle"
    let BlockName = "block"
    let BallName = "ball"
    
    let PaddleCategory : UInt32 = 1 << 0
    let BlockCategory : UInt32 = 1 << 1
    let BallCategory : UInt32 = 1 << 2
    
    weak var paddle : SKNode?
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        addGrid()
        
        addPaddle()
        addBlocks()
        
        self.physicsWorld.contactDelegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("addBall"))
        tapRecognizer.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(tapRecognizer)
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
        
        paddle.name = PaddleName
        
        let paddleBody = SKPhysicsBody(rectangleOfSize: PaddleSize)
        paddleBody.affectedByGravity = false
        paddleBody.categoryBitMask = PaddleCategory
        paddleBody.collisionBitMask = BallCategory
        paddleBody.contactTestBitMask = BallCategory
        paddleBody.dynamic = false
        
        paddle.physicsBody = paddleBody
        
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
                
                let blockBody = SKPhysicsBody(rectangleOfSize: BlockSize)
                blockBody.affectedByGravity = false
                blockBody.categoryBitMask = BlockCategory
                blockBody.collisionBitMask = BallCategory
                blockBody.contactTestBitMask = BallCategory
                blockBody.dynamic = false
                
                block.physicsBody = blockBody
                
                addChild(block)
            }
        }
    }
    
    func addBall() {
        let ball = SKSpriteNode(color: BallColor, size: BallSize)
        if let paddlePoint = paddle?.frame.origin {
            ball.position = CGPoint(x: paddlePoint.x, y: paddlePoint.y + CGFloat(BallPaddleOffset))
            
            ball.name = BallName
            
            let ballBody = SKPhysicsBody(circleOfRadius: BallSize.width / 2)
            ballBody.velocity = BallStartVelocity
            ballBody.affectedByGravity = false
            ballBody.categoryBitMask = BallCategory
            ballBody.collisionBitMask = PaddleCategory | BlockCategory
            ballBody.contactTestBitMask = ballBody.collisionBitMask
            ballBody.usesPreciseCollisionDetection = true
            
            ball.physicsBody = ballBody
            
            addChild(ball)
        } else {
            print("No Paddle")
        }
        
    }
    func setPaddlePosition(x:CGFloat) {
        paddle?.position.x = x
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("contactbegin", contact)
        let node1 = contact.bodyA.node;
        let node2 = contact.bodyB.node;
        
        var ball : SKNode?
        var block : SKNode?
        if (node1?.name == BlockName) {
            ball = node2
            block = node1
        } else if (node2?.name == BlockName) {
            ball = node1
            block = node2
        }
        block?.removeFromParent()
        
        guard ball?.physicsBody != nil else {
            return
        }
        let body = ball!.physicsBody!
        let velocity = body.velocity
        
        let newVelocity = CGVector(dx: velocity.dx * -1, dy: velocity.dy * -1)
        body.velocity = newVelocity
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        print("contactend", contact)
    }
}
