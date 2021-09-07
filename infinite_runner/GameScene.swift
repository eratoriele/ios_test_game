//
//  GameScene.swift
//  infinite_runner
//
//  Created by macos on 7.09.2021.
//  Copyright © 2021 macos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let player = SKSpriteNode(imageNamed: "playerShip")
    
    override func didMove(to view: SKView) {
        
        // create the background as big as the screen
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = zPositions.background
        self.addChild(background)
        
        player.setScale(1)
        player.position = CGPoint(
            x: self.size.width * playerStartingPosition.xMultiplier,
            y: self.size.height * playerStartingPosition.yMultiplier)
        player.zPosition = zPositions.player
        // Player should fire bullets periodically, without input
        let fireAction = SKAction.run {
            self.fireBullet(firedFrom: self.player.position,
                            direction: bulletConstants.direction.up)
        }
        let constantlyFire = SKAction.repeatForever(
            SKAction.sequence([fireAction, SKAction.wait(forDuration: bulletConstants.reAttackTime)]))
        player.run(constantlyFire)

        self.addChild(player)
        
    }
    
    // Fire a bullet,it can be fired both up, by the player, and down by an enemy
    func fireBullet(firedFrom: CGPoint, direction: bulletConstants.direction) {
        
        // Default is for firing up
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = firedFrom
        bullet.zPosition = zPositions.bullet
        // Rotate the bullet if it is going down
        if direction == bulletConstants.direction.down {
            bullet.zRotation = CGFloat.pi
        }
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        
        bullet.run(bulletSequence)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let touchPoint = touch.location(in: self)
            let previousTouchPoint = touch.previousLocation(in: self)
            
            player.position.x += touchPoint.x - previousTouchPoint.x
            player.position.y += touchPoint.y - previousTouchPoint.y
        }
        
    }
    
}


