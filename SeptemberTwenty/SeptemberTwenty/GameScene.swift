//
//  GameScene.swift
//  SeptemberTwenty
//
//  Created by Luis Reisewitz on 20.09.15.
//  Copyright (c) 2015 ZweiGraf. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: Constants
    let PaddleColor = UIColor.red.withAlphaComponent(0.5)
    let BlockColor = UIColor.green.withAlphaComponent(0.5)
    let BallColor = UIColor.blue.withAlphaComponent(0.5)
    
    let PaddleSize = CGSize(width: 200, height: 25)
    let BlockSize = CGSize(width: 100, height: 50)
    let BallSize = CGSize(width: 20, height: 20)
    
    let PaddleBottomOffset = 50
    let BlockTopOffset = 68
    let BlockLeftOffset : CGFloat = 50
    let BlockRightOffset : CGFloat = 50
    let BlockRowCount = 4
    let BallPaddleOffset = 100
    
    let BallStartVelocity = CGVector(dx: 50, dy: 300)
    
    let PaddleName = "paddle"
    let BlockName = "block"
    let BallName = "ball"
    let LoseSensorName = "losesensor"
    
    let PaddleCategory : UInt32 = 1 << 0
    let BlockCategory : UInt32 = 1 << 1
    let BallCategory : UInt32 = 1 << 2
    let WallsCategory : UInt32 = 1 << 3
    let LoseSensorCategory : UInt32 = 1 << 4
    
    weak var paddle : SKNode?
    
    // MARK: SKScene Overrides
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFit
        
        addWalls()
        addGrid()
        
        addPaddle()
        addBlocks()
        
        addLoseSensor()
        
        self.physicsWorld.contactDelegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.addBall))
        tapRecognizer.numberOfTapsRequired = 2
        self.view?.addGestureRecognizer(tapRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            setPaddlePosition(location.x)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            setPaddlePosition(location.x)
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: SKNode Creation
    
    func addWalls() {
        // just normal walls for the ball to reflect from
        let walls = SKPhysicsBody(edgeLoopFrom: self.frame)
        walls.categoryBitMask = WallsCategory
        walls.collisionBitMask = BallCategory
        walls.friction = 0.0
        walls.restitution = 1.0
        self.physicsBody = walls
    }
    
    func addGrid() {
        let grid = GridGenerator.createGrid(self.frame, step: 50)
        grid.zPosition = -1
        addChild(grid)
    }
    
    func addPaddle() {
        let texture = SKTexture(imageNamed: "Paddle_Blue")
        let paddle = SKSpriteNode(texture: texture)
        paddle.position = CGPoint(x: Int(self.frame.midX), y: PaddleBottomOffset)
        
        paddle.name = PaddleName
        
        let paddleBody = SKPhysicsBody(texture: texture, size: PaddleSize)
        paddleBody.affectedByGravity = false
        paddleBody.categoryBitMask = PaddleCategory
        paddleBody.collisionBitMask = BallCategory
        paddleBody.contactTestBitMask = BallCategory
        paddleBody.friction = 0.0
        paddleBody.restitution = 1.0
        paddleBody.isDynamic = false
        
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
        
        let yOfFirstBlock = self.frame.maxY - CGFloat(BlockTopOffset) - (BlockSize.height / 2)
        let yOfLastBlock = yOfFirstBlock - (CGFloat(BlockRowCount - 1) * BlockSize.height)
        
        for var y = yOfFirstBlock; y >= yOfLastBlock; y -= BlockSize.height {
            for var x = xOfFirstBlock; x <= xOfLastBlock; x += BlockSize.width {
                let block = SKSpriteNode(imageNamed: "Block_Yellow")
                block.position = CGPoint(x: x, y: y)
                
                block.name = BlockName;
                
                let blockBody = SKPhysicsBody(rectangleOf: BlockSize)
                blockBody.affectedByGravity = false
                blockBody.categoryBitMask = BlockCategory
                blockBody.collisionBitMask = BallCategory
                blockBody.contactTestBitMask = BallCategory
                blockBody.friction = 0.0
                blockBody.restitution = 1.0
                blockBody.isDynamic = false
                
                block.physicsBody = blockBody
                
                addChild(block)
            }
        }
    }
    
    func addBall() {
        let ball = SKSpriteNode(imageNamed: "Ball_Grey")
        if let paddlePoint = paddle?.frame.origin {
            ball.position = CGPoint(x: paddlePoint.x, y: paddlePoint.y + CGFloat(BallPaddleOffset))
            
            ball.name = BallName
            
            let ballBody = SKPhysicsBody(circleOfRadius: BallSize.width / 2)
            
            ballBody.velocity = BallStartVelocity
            ballBody.affectedByGravity = false
            ballBody.restitution = 1.0
            ballBody.linearDamping = 0.0
            ballBody.angularDamping = 0.0
            ballBody.friction = 0.0
            
            ballBody.categoryBitMask = BallCategory
            ballBody.collisionBitMask = WallsCategory | PaddleCategory | BlockCategory
            ballBody.contactTestBitMask = PaddleCategory | BlockCategory | LoseSensorCategory
            ballBody.usesPreciseCollisionDetection = true
            
            ball.physicsBody = ballBody
            
            addChild(ball)
        } else {
            print("No Paddle")
        }
        
    }
    
    func addLoseSensor() {
        let x0 = self.frame.origin.x
        let x1 = x0 + self.frame.size.width
        let y = self.frame.origin.y
        
        let loseSensor = SKNode()
        
        loseSensor.name = LoseSensorName
        
        let body = SKPhysicsBody(edgeFrom: CGPoint(x: x0, y: y + 10), to: CGPoint(x: x1, y: y + 10))
        body.collisionBitMask = 0x0
        body.contactTestBitMask = BallCategory
        
        loseSensor.physicsBody = body
        
        addChild(loseSensor)
    }
    
    // MARK: State methods
    
    func setPaddlePosition(_ x:CGFloat) {
        let min = self.frame.minX + (PaddleSize.width / 2)
        let max = self.frame.maxX - (PaddleSize.width / 2)
        let newX = clamp(x, lower: min, upper: max)
        paddle?.position.x = newX
    }
    
    func collideBall(_ ball: SKNode, withBlock block: SKNode) {
        block.removeFromParent()
    }
    
    func collideBall(_ ball: SKNode, withPaddle paddle: SKNode) {
        
    }
    
    func collideBall(_ ball: SKNode, withSensor sensor: SKNode) {
        ball.removeFromParent()
    }
    
    // MARK: SKPhysicsContactsDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        let node1 = contact.bodyA.node
        let node2 = contact.bodyB.node
        
        guard node1?.name != nil && node2?.name != nil else {
            return
        }
        let name1 = node1!.name!
        let name2 = node2!.name!
        
        switch name1 {
        case BallName:
            switch name2 {
            case PaddleName:
                collideBall(node1!, withPaddle: node2!)
            case BlockName:
                collideBall(node1!, withBlock: node2!)
            case LoseSensorName:
                collideBall(node1!, withSensor: node2!)
            default:
                break
            }
        case PaddleName:
            switch name2 {
            case BallName:
                collideBall(node2!, withPaddle: node1!)
            default:
                break
            }
        case BlockName:
            switch name2 {
            case BallName:
                collideBall(node2!, withBlock: node1!)
            default:
                break
            }
        case LoseSensorName:
            switch name2 {
            case BallName:
                collideBall(node2!, withSensor: node1!)
            default:
                break
            }
        default:
            break
        }
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
//        print("contactend", contact)
        
        
    }
    
    // MARK: Helper
    
    ///From https://gist.github.com/leemorgan/bf1a0a1a8b2c94bce310
    ///Returns the input value clamped to the lower and upper limits.
    func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }

}
