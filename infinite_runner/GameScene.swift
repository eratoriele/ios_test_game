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
    var gameArea: CGRect = CGRect()
    
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        
        // Spawn enemies every few seconds
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.spawnEnemy()
        }
        
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
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.position.y + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        
        bullet.run(bulletSequence)
    }
    
    func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        
        let randomXStart = CGFloat.random(in: gameArea.minX...gameArea.maxX)
        let YStart = gameArea.maxY + enemy.size.height / 2
        let randomXDest = CGFloat.random(in: gameArea.minX...gameArea.maxX)
        let YDest = gameArea.minY - enemy.size.height / 2
        
        let startPoint = CGPoint(x: randomXStart, y: YStart)
        let endPoint = CGPoint(x: randomXDest, y: YDest)
        
        enemy.position = startPoint
        enemy.zPosition = zPositions.enemy
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let rotateAmount = atan2(dy, dx)
        
        enemy.zRotation = rotateAmount
                
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let touchPoint = touch.location(in: self)
            let previousTouchPoint = touch.previousLocation(in: self)
            let xMoveDistance = touchPoint.x - previousTouchPoint.x
            let yMoveDistance = touchPoint.y - previousTouchPoint.y
            
            print("player position: ", player.position)
            print("gameArea max X: ", gameArea.maxX)
            print("gameArea min X: ", gameArea.minX)
            print("gameArea max y: ", gameArea.maxY)
            
            // If the player goes too much right
            if player.position.x + player.size.width/2 + xMoveDistance > gameArea.maxX {
                player.position.x = gameArea.maxX - player.size.width/2
            }
            // If the player goes too much left
            else if player.position.x - player.size.width/2 + xMoveDistance < gameArea.minX {
                player.position.x = gameArea.minX + player.size.width/2
            }
            else {
                player.position.x += xMoveDistance
            }
            // If the player goes too much up
            if player.position.y + player.size.height/2 + yMoveDistance > gameArea.maxY {
                player.position.y = gameArea.maxY - player.size.height/2
            }
            // If the player goes too much down
            else if player.position.y - player.size.height/2 + xMoveDistance < gameArea.minY {
                player.position.y = gameArea.minY + player.size.height/2
            }
            // Movement is inside the game area
            else {
                player.position.y += yMoveDistance
            }
        }
        
    }
    
}


