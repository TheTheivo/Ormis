//
//  GameViewController.swift
//  Ormis
//
//  Created by Robin Sullivan on 18/01/2018.
//  Copyright © 2018 Robin Sullivan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GKScene(fileNamed: "GameScene"){
            let skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            if let sceneNode = scene.rootNode as! GameScene?{
                sceneNode.scaleMode = .aspectFill
                skView.presentScene(sceneNode)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    } 
}
 
