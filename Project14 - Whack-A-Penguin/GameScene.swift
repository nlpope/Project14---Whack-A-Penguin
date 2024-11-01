//
//  GameScene.swift
//  Project14 - Whack-A-Penguin
//
//  Created by Noah Pope on 10/2/24.
//

import SpriteKit

class GameScene: SKScene {
    var slots       = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popupTime   = 0.85
    var numRounds   = 0
    var score       = 0 {
        didSet { gameScore.text = "Score: \(score)" }
    }
    
    
    override func didMove(to view: SKView) {
        let background                      = SKSpriteNode(imageNamed: ImageKeys.whackBackground)
        background.position                 = CGPoint(x: 512, y: 384)
        background.blendMode                = .replace
        background.zPosition                = -1
        addChild(background)
        
        gameScore                           = SKLabelNode(fontNamed: FontKeys.chalkduster)
        gameScore.text                      = "Score: 0"
        gameScore.position                  = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode   = .left
        gameScore.fontSize                  = 48
        addChild(gameScore)
        
        for i in 0..<5 { ccreateSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 { ccreateSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 { ccreateSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 { ccreateSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.showPenguins()
        }
    }
    
    
    func ccreateSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }

    //committing unsaved changes
    func showPenguins() {
        numRounds += 1
        if numRounds >= 30 {
            for slot in slots { slot.hide() }
    
            let gameOver            = SKSpriteNode(imageNamed: ImageKeys.gameOver)
            gameOver.position       = CGPoint(x: 512, y: 384)
            gameOver.zPosition      = 1
            addChild(gameOver)
                
            let finalScore          = SKLabelNode(fontNamed: FontKeys.chalkduster)
            finalScore.text         = "Final Score: \(score)"
            finalScore.position     = CGPoint(x: 512, y: 200)
            finalScore.fontSize     = 100
            finalScore.zPosition    = 1
            addChild(finalScore)
            
            run(SKAction.playSoundFileNamed(SoundKeys.gameOver, waitForCompletion: false))

            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)}
        
        let minDelay    = popupTime / 2.0
        let maxDelay    = popupTime * 2
        let delay       = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.showPenguins()
        }
    }
    
    
    func grindGears(onSlot slot: SKNode) {
        if let smokeParticles       = SKEmitterNode(fileNamed: EmitterKeys.smokeEmitter) {
            smokeParticles.position = slot.position
            addChild(smokeParticles)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch     = touches.first else { return }
        let location        = touch.location(in: self)
        let tappedNodes     = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == NodeNameKeys.charEnemy {
                score -= 5
    
                run(SKAction.playSoundFileNamed(SoundKeys.whackBad, waitForCompletion: false))
                grindGears(onSlot: whackSlot)
                
            } else if node.name == NodeNameKeys.charFriend {
                whackSlot.charNode.xScale   = 0.85
                whackSlot.charNode.yScale   = 0.85
                score += 1
                
                run(SKAction.playSoundFileNamed(SoundKeys.whackGood, waitForCompletion: false))
            }
        }
    }
}
