//
//  SpinnyNode.swift
//  Ormis
//
//  Created by Robin Sullivan on 18/01/2018.
//  Copyright © 2018 Robin Sullivan. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpinnyNode: SKScene {
    private var spinnyNode : SKShapeNode?
    
    var width = 0
    var height = 0
    func initialize(cornerRadiusNode: CGFloat, w: CGFloat) -> SKShapeNode
    {
        
        // Create shape node to use during mouse interaction
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * cornerRadiusNode)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.moveBy(x: -1000,y: -5, duration: 5.0),
                                              
                                              SKAction.removeFromParent()]))
        }
        return (self.spinnyNode!)
    }
}
