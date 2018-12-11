//
// GameScene.swift
// betaproject
//
// Created by August Murphy-Beach on 11/26/18.
// Copyright © 2018 August Murphy-Beach. All rights reserved
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let guy: UInt32 = 1
    static let wheel: UInt32 = 2
    static let ground: UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var label : SKLabelNode?
    var guyNode = SKCameraNode()
    private var backgroundNode : SKSpriteNode?
    private var frontWheelNode: SKSpriteNode?
    var rearWheelNode = SKSpriteNode()
    
    let cam = SKCameraNode()
    var highScore: Int = -1
    var theme: UIColor = UIColor.white
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.addChild(cam)
        self.camera = cam
        scene?.camera = cam
        
        print("Frame width: ¥(self.frame.width) height: ¥(self.frame.height)")
        print("maxX: ¥(self.frame.maxX) minX: ¥(self.frame.minX)")
        print("maxY: ¥(self.frame.maxY) minY: ¥(self.frame.minY)")
        print("midX: ¥(self.frame.midX) midY: ¥(self.frame.midY)")
        
        startGame()
    }
    
    func startGame(){
        
        initGround(map_number: 1)
        initSky(sky_number: 1)
        initGuy()
        
    }
    
    func initGuy(){
        let guyTexture = SKTexture(imageNamed: "guy.png") // define a texture that holds our guy
        let guyNode = SKSpriteNode(texture: guyTexture) // make a new guy node
        
        guyNode.physicsBody = SKPhysicsBody(circleOfRadius: max(guyNode.size.width / 2, guyNode.size.height / 2)) // this creates a circular physics collision 'bubble' around *ourguy*
        guyNode.physicsBody = SKPhysicsBody(texture: guyTexture, size: CGSize(width: guyNode.size.width, height: guyNode.size.height))
        guyNode.physicsBody?.usesPreciseCollisionDetection = true
        guyNode.physicsBody?.restitution = 0.2
        guyNode.position = CGPoint(x: 0, y: 100)
        guyNode.physicsBody?.categoryBitMask = ColliderType.guy
        guyNode.physicsBody?.collisionBitMask = ColliderType.ground
        guyNode.physicsBody?.contactTestBitMask = ColliderType.ground
        guyNode.physicsBody?.mass = 0.1
        
        //guyNode.physicsBody?.isDynamic = false
        
        // *********** CREATE FRONT WHEEL*********
        let wheelTexture = SKTexture(imageNamed: "guy_wheel.png") // define a texture that holds our guy
        let frontWheelNode = SKSpriteNode(texture: wheelTexture) // make a new guy node
        
        frontWheelNode.physicsBody = SKPhysicsBody(circleOfRadius: max(frontWheelNode.size.width / 2, frontWheelNode.size.height / 2)) // this creates a circular physics collision 'bubble' around *ourguy*
        frontWheelNode.physicsBody?.usesPreciseCollisionDetection = true
        frontWheelNode.physicsBody?.restitution = 0.2
        frontWheelNode.physicsBody?.categoryBitMask = ColliderType.wheel
        frontWheelNode.physicsBody?.collisionBitMask = ColliderType.ground
        frontWheelNode.physicsBody?.contactTestBitMask = ColliderType.ground
        frontWheelNode.physicsBody?.friction = 1.0
        frontWheelNode.physicsBody?.allowsRotation = true
        frontWheelNode.physicsBody?.mass = 1
        frontWheelNode.position = CGPoint(x: 45, y: 60)
        
        // *********** CREATE REAR WHEEL *********
        
        rearWheelNode = SKSpriteNode(texture: wheelTexture)
        rearWheelNode.physicsBody = SKPhysicsBody(circleOfRadius: max(rearWheelNode.size.width / 2, rearWheelNode.size.height / 2))
        rearWheelNode.physicsBody?.usesPreciseCollisionDetection = true
        rearWheelNode.physicsBody?.restitution = 0.2
        rearWheelNode.physicsBody?.categoryBitMask = ColliderType.wheel
        rearWheelNode.physicsBody?.collisionBitMask = ColliderType.ground
        rearWheelNode.physicsBody?.contactTestBitMask = ColliderType.ground
        rearWheelNode.physicsBody?.isDynamic = true
        rearWheelNode.physicsBody?.friction = 1.0
        rearWheelNode.physicsBody?.allowsRotation = true
        rearWheelNode.physicsBody?.mass = 1.5
        rearWheelNode.position = CGPoint(x: -40, y: 65)
        
        let frontJoin = SKPhysicsJointSpring()
        frontJoin.bodyA = guyNode.physicsBody!
        frontJoin.bodyB = frontWheelNode.physicsBody!
        
        self.addChild(guyNode)
        self.addChild(frontWheelNode)
        self.addChild(rearWheelNode)
        
        let front_pin_anchor = CGPoint(x: frontWheelNode.position.x, y: frontWheelNode.position.y)
        let rear_pin_anchor = CGPoint(x: rearWheelNode.position.x,y: rearWheelNode.position.y)
        let front_pin = SKPhysicsJointPin.joint(withBodyA: guyNode.physicsBody!, bodyB: frontWheelNode.physicsBody!, anchor: front_pin_anchor)
        
        self.physicsWorld.add(front_pin)
        let rear_pin = SKPhysicsJointPin.joint(withBodyA: guyNode.physicsBody!, bodyB: rearWheelNode.physicsBody!, anchor: rear_pin_anchor)
        self.physicsWorld.add(rear_pin)
        
        let rotate = SKAction.rotate(byAngle: -3000, duration: 40)
        rearWheelNode.run(rotate)
    }
    
    func initGround(map_number: Int) -> Void{
        let GroundTexture = SKTexture(imageNamed: "map3")
        let circularGround = SKSpriteNode(texture: GroundTexture)
        circularGround.physicsBody = SKPhysicsBody(circleOfRadius: max(circularGround.size.width / 2, circularGround.size.height / 2))
        let GroundNode = SKSpriteNode(texture: GroundTexture)
        
        GroundNode.physicsBody = SKPhysicsBody(texture: GroundTexture, size: CGSize(width: circularGround.size.width, height: circularGround.size.height))
        GroundNode.physicsBody?.usesPreciseCollisionDetection = true
        GroundNode.physicsBody?.restitution = 0.2
        //GroundNode.physicsBody?.collisionBitMask = 2
        GroundNode.physicsBody?.categoryBitMask = 4
        GroundNode.physicsBody?.isDynamic = false
        GroundNode.physicsBody?.friction = 1
        GroundNode.position = CGPoint(x: 1900, y: -300)
        self.addChild(GroundNode)
    }
    
    func initSky(sky_number: Int) -> Void{
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        rearWheelNode.physicsBody?.applyTorque(-400.0)
        rearWheelNode.physicsBody?.applyForce(CGVector(dx: 0, dy: 1000))
        
        print(rearWheelNode.physicsBody?.allContactedBodies())
        print("torque it up!")
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position.y = guyNode.position.y
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // check if bodyA or bodyB is a basketball
        // no guarantee on order
        if contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2 {
            print("We have contact with the ground")
            print(contact.bodyA.allContactedBodies())
        }
        else if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            print("Collision with guy")
        }
    }
}
