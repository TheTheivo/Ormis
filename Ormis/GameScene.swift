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
    var trail = RingBuffer<CGPoint>(count: 20) // ring buffer for the tail and vector of the movement
    let PlayerCategory : UInt32 = 0x1 << 0
    let EnemyCategory : UInt32 = 0x1 << 1
    let WallCategory : UInt32 = 0x1 << 2
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var atlas : SKTextureAtlas?
    let player = SKSpriteNode(imageNamed: "PlayerBaseBall")
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to: SKView) {
        self.atlas = SKTextureAtlas(named: "Sprites")
        self.player.position = CGPointFromString("{0,0}")
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: (view?.frame)!)
        self.physicsBody?.categoryBitMask = WallCategory
        self.physicsBody?.contactTestBitMask = PlayerCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.friction = 0
        
        self.player.physicsBody?.categoryBitMask = PlayerCategory
        self.player.physicsBody?.contactTestBitMask = EnemyCategory | WallCategory
        self.player.physicsBody?.collisionBitMask = 0
        self.player.physicsBody?.isDynamic = true
        self.player.physicsBody?.affectedByGravity = false

        
        addChild(self.player)
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
    
    func createPlayer(){
        
    }
    
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (firstNum - secondNum) + min(firstNum, secondNum)
    }
    //Helper method for spawning a point along the screen borders. This will not work for diagonal lines.
    func randomPointBetween(start:CGPoint, end:CGPoint) -> CGPoint{
        
        return CGPoint(x: randomBetweenNumbers(firstNum: start.x, secondNum: end.x), y: randomBetweenNumbers(firstNum: start.y, secondNum: end.y))
    }
    
    
    func createEnemies(){
        
        //Randomize spawning time.
        //This will create a node every 0.5 +/- 0.1 seconds, means between 0.4 and 0.6 sec
        //TODO: decrase spawning time based of time played
        let wait = SKAction .wait(forDuration:0.5, withRange: 0.2)
        
        
        weak var  weakSelf = self
        
        
        let spawn = SKAction.run({
            
            let random = arc4random() % 4 +  1
            var position = CGPoint()
            var moveTo = CGPoint()

            //print(random)

            switch random {
                
            //Top
            case 1:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: -(weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)))
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)), end: CGPoint(x:-(weakSelf!.frame.height/2), y:-(weakSelf!.frame.height/2)))
                break
            //Bottom
            case 2:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)), end: CGPoint(x: -(weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)))
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: -(weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)))
                break
            //Left
            case 3:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: -(weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: -(weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)))
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: (weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)))
                break
            //Right
            case 4:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: (weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: (weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)))
                
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: -(weakSelf!.frame.width/2), y: (weakSelf!.frame.height/2)), end: CGPoint(x: -(weakSelf!.frame.width/2), y: -(weakSelf!.frame.height/2)))
                break
                
            default:
                break
                
            }
            
            weakSelf!.spawnEnemyAtPosition(position: position, moveTo: moveTo)
            
        })
        
        let spawning = SKAction.sequence([wait,spawn])
        
        self.run(SKAction.repeatForever(spawning), withKey:"spawning")
        
        
    }
    
    
    func spawnEnemyAtPosition(position:CGPoint, moveTo:CGPoint){
        
        let enemy = SKSpriteNode(color: SKColor.brown, size: CGSize(width: 40, height: 40))
        
        
        enemy.position = position
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = EnemyCategory
        enemy.physicsBody?.contactTestBitMask = PlayerCategory
        enemy.physicsBody?.collisionBitMask = 0 // no collisions
        let move = SKAction.move(to:moveTo, duration: 2)
        let remove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([move, remove]))
        
        
        self.addChild(enemy)
        
    }
    
    func loadPlayer(){
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
    }

    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        var written = trail.write(pos)
        if (trail.cheeckDoableVector)
        {
            weak var  weakSelf = self
            var trailNode =  SKShapeNode.init(rectOf: CGSize.init(width: 20, height: 20), cornerRadius: 1)
            trailNode.fillColor = SKColor.cyan
            trailNode.position = self.player.position
            trailNode.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                            SKAction.removeFromParent()]))
            self.addChild(trailNode)
            let firstPoint = trail.read()
            let secondPoint = trail.read()
            
            var x = Float(firstPoint!.x) - Float(secondPoint!.x) + Float(self.player.position.x)
            var y = Float(firstPoint!.y) - Float(secondPoint!.y) + Float(self.player.position.y)

            print("X: [" + weakSelf!.frame.width.description + ", Y: " + weakSelf!.frame.height.description + "] ")
            print("X: [" + x.description + ", Y: " + y.description + "] ")
            let cgPointString = "{" + x.description + "," + y.description + "}"
            self.player.position = CGPointFromString(cgPointString)
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
