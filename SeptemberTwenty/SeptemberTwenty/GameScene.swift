//
//  GameScene.swift
//  SeptemberTwenty
//
//  Created by Luis Reisewitz on 20.09.15.
//  Copyright (c) 2015 ZweiGraf. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        let grid = GridGenerator.createGrid(self.frame, step: 50)
        grid.zPosition = -1
        addChild(grid)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            print(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
