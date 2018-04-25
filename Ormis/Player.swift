//
//  Player.swift
//  Ormis
//
//  Created by Robin Sullivan on 21/01/2018.
//  Copyright © 2018 Robin Sullivan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player : SKSpriteNode {
    
    private var x : CGFloat
    {
        get{
            return self.position.x
        }
        set(x){
            self.position.x = x
        }
    }
    private var y : CGFloat
    {
        get{
            return self.position.x
        }
        set(x){
            self.position.x = x
        }
    }
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    /**
     Moves sprite by given points
     
     - parameters:
     - firstPoint: CGPoint saved in ringbuffer
     - secondPoint: CGPoint saved in ringbuffer
     */
    func move(firstPoint : CGPoint, secondPoint : CGPoint) {
        let x = -(Float(firstPoint.x) - Float(secondPoint.x)) + Float(self.position.x)
        let y = -(Float(firstPoint.y) - Float(secondPoint.y)) + Float(self.position.y)
        let cgPointString = "{" + x.description + "," + y.description + "}"
        self.position = CGPointFromString(cgPointString)
    }
    /**
     Builds enemy node
     
     - returns:
     SKSpriteNode
     
     - parameters:
     - PlayerCategory: Bit mask for the player sprite
     - EnemyCategory: Bit mask for the enemy node sprite
     - WallCategory: Bit mask for the borders of the screen
     */
    func spawn(PlayerCategory : UInt32, EnemyCategory : UInt32, WallCategory : UInt32) -> SKSpriteNode
    {
        self.physicsBody?.categoryBitMask = PlayerCategory
        self.physicsBody?.contactTestBitMask = EnemyCategory | WallCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.position.x = 0.0
        self.position.y = 0.0
        return self
    }    
}
