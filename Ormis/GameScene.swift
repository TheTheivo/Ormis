//
//  GameScene.swift
//  Ormis
//
//  Created by Robin Sullivan on 18/01/2018.
//  Copyright © 2018 Robin Sullivan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var trail = RingBuffer<CGPoint>(count: 20) // ring buffer for the vector of the movement
    // bits representing mask of the sprites used for contact detection
    let PlayerCategory : UInt32 = 0x1 << 0
    let EnemyCategory : UInt32 = 0x1 << 1
    let WallCategory : UInt32 = 0x1 << 2
    
    private var lastUpdateTime : TimeInterval = 0
    var player : Player?
    private var atlas : SKTextureAtlas?
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to: SKView) {
        self.atlas = SKTextureAtlas(named: "Sprites")
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: (view?.frame)!)
        self.physicsBody?.categoryBitMask = WallCategory
        self.physicsBody?.contactTestBitMask = PlayerCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.friction = 0
        
        createPlayer()
        createEnemies()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.physicsBody?.categoryBitMask == WallCategory && contact.bodyA.node?.physicsBody?.categoryBitMask == PlayerCategory)
        {
            
        }
    }
    func colisionPlayerWithWall()
    {
        
    }
    deinit{
        print("deinit called")
    }
    /**
     Creates player and inserts it into the scene
     */
    func createPlayer(){
        self.player = Player(texture: self.atlas?.textureNamed("PlayerBaseBall"), color: UIColor.white, size: CGSize(width: 40, height: 40))
        addChild((self.player?.spawn(PlayerCategory: PlayerCategory, EnemyCategory: EnemyCategory, WallCategory: WallCategory))!)
    }
    /**
     Creates one enemie node by given time and inserts him into the scene. This runs in loop.
     */
    func createEnemies(){
        //Randomize spawning time.
        //This will create a node every 0.5 +/- 0.1 seconds, means between 0.4 and 0.6 sec
        //TODO: decrase spawning time based on time played
        let wait = SKAction .wait(forDuration:0.5, withRange: 0.2)
        weak var  weakSelf = self
        
        let spawn = SKAction.run({
            let enemy = EnemyNode(texture: nil, color: UIColor.green, size: CGSize(width: 40, height: 40))
            self.addChild(enemy.spawn(frameWidth: (weakSelf?.frame.width)!, frameHeight: (weakSelf?.frame.height)!, PlayerCategory : self.PlayerCategory, EnemyCategory : self.EnemyCategory))
        })
        let spawning = SKAction.sequence([wait,spawn])
        self.run(SKAction.repeatForever(spawning), withKey:"spawning")
    }

    func didBeginContact(contact: SKPhysicsContact) {
        
        
    }

    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        var written = trail.write(pos)
        if (trail.cheeckDoableVector)
        {
            let firstPoint = trail.read()
            let secondPoint = trail.read()
            player?.move(firstPoint : firstPoint!, secondPoint: secondPoint!)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
            trail = RingBuffer<CGPoint>(count: 20)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {

        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
