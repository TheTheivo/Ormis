//
//  EnemyNode.swift
//  Ormis
//
//  Created by Robin Sullivan on 24/04/2018.
//  Copyright © 2018 Robin Sullivan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EnemyNode : SKSpriteNode{
    
    private var moveTo = CGPoint()
    private var frameWidth : CGFloat
    private var frameHeight : CGFloat
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize)
    {
        self.frameHeight = 0
        self.frameWidth = 0
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Builds enemy node
     
     - returns:
     SKSpriteNode
     
     - parameters:
     - frameWidth: Width of the screen
     - frameHeight: Height of the screen
     - PlayerCategory: Bit mask for the player sprite
     - EnemyCategory: Bit mask for the enemy node sprite
     */
    
    func spawn(frameWidth : CGFloat, frameHeight: CGFloat, PlayerCategory : UInt32, EnemyCategory : UInt32) -> SKSpriteNode
    {
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        
        createTrajectory()
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = EnemyCategory
        self.physicsBody?.contactTestBitMask = PlayerCategory
        self.physicsBody?.collisionBitMask = 0 // no collisions
        let move = SKAction.move(to:moveTo, duration: 2)
        let remove = SKAction.removeFromParent()
        self.run(SKAction.sequence([move, remove]))
        return self
    }
    
    private func createTrajectory()
    {
        let random = arc4random() % 4 +  1
        switch random {
            
        //Top
        case 1:
            position = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: -(self.frameWidth/2), y: (self.frameHeight/2)))
            //Move to opposite side
            moveTo = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: -(self.frameHeight/2)), end: CGPoint(x:-(self.frameHeight/2), y:-(self.frameHeight/2)))
            break
        //Bottom
        case 2:
            position = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: -(self.frameHeight/2)), end: CGPoint(x: -(self.frameWidth/2), y: -(self.frameHeight/2)))
            //Move to opposite side
            moveTo = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: -(self.frameWidth/2), y: (self.frameHeight/2)))
            break
        //Left
        case 3:
            position = randomPointBetween(start: CGPoint(x: -(self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: -(self.frameWidth/2), y: -(self.frameHeight/2)))
            //Move to opposite side
            moveTo = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: (self.frameWidth/2), y: -(self.frameHeight/2)))
            break
        //Right
        case 4:
            position = randomPointBetween(start: CGPoint(x: (self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: (self.frameWidth/2), y: -(self.frameHeight/2)))
            
            //Move to opposite side
            moveTo = randomPointBetween(start: CGPoint(x: -(self.frameWidth/2), y: (self.frameHeight/2)), end: CGPoint(x: -(self.frameWidth/2), y: -(self.frameHeight/2)))
            break
            
        default:
            break
            
        }
    }
    
    private func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (firstNum - secondNum) + min(firstNum, secondNum)
    }
    //Helper method for spawning a point along the screen borders. This will not work for diagonal lines.
    private func randomPointBetween(start:CGPoint, end:CGPoint) -> CGPoint{
        
        return CGPoint(x: randomBetweenNumbers(firstNum: start.x, secondNum: end.x), y: randomBetweenNumbers(firstNum: start.y, secondNum: end.y))
    }
}
