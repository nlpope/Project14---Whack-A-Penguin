//
//  WhackSlot.swift
//  Project14 - Whack-A-Penguin
//
//  Created by Noah Pope on 10/2/24.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisible   = false
    var isHit       = false
    
    // why don't we use init here again?
    func configure(at position: CGPoint) {
        self.position   = position
        
        let sprite      = SKSpriteNode(imageNamed: ImageKeys.whackHole)
        addChild(sprite) 
        
        let cropNode        = SKCropNode()
        cropNode.position   = CGPoint(x: 0, y: 15)
        cropNode.zPosition  = 1
        cropNode.maskNode   = SKSpriteNode(imageNamed: ImageKeys.whackMask)
        
        charNode            = SKSpriteNode(imageNamed: ImageKeys.penguinGood)
        charNode.position   = CGPoint(x: 0, y: -90)
        charNode.name       = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible       = true
        isHit           = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture    = SKTexture(imageNamed: ImageKeys.penguinGood)
            charNode.name       = NodeNameKeys.charFriend
        } else {
            charNode.texture    = SKTexture(imageNamed: ImageKeys.penguinEvil)
            charNode.name       = NodeNameKeys.charEnemy
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            guard let self = self else { return }
            self.hide()
        }
    }
    
    
#warning("differentiate hide / hit / scale behavior")
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible   = false
    }
    
    
    #warning("differentiate hide / hit / scale behavior")
    func hit() {
        isHit           = true
        let delay       = SKAction.wait(forDuration: 0.25)
        // add penguin shake functionality here via ternary op
        let hide        = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible  = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}

// adding notes
