//
//  GameScene.swift
//  betaproject
//
//  Created by August Murphy-Beach on 11/26/18.
//  Copyright © 2018 August Murphy-Beach. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ColliderType {
    static let guy: UInt32 = 1
    static let wheel: UInt32 = 2
    static let ground: UInt32 = 4
    static let finish: UInt32 = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    var guyNode = SKCameraNode()
    private var backgroundNode : SKSpriteNode?
    private var frontWheelNode: SKSpriteNode?
    var rearWheelNode = SKSpriteNode()
    let cam = SKCameraNode()
    var gameOverImage = SKSpriteNode()
    var gameWinImage = SKSpriteNode()
    let FinishLineNode = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var finishPosition : Int = 7950
    var viewController: GameViewController?
    var diffculty_rating: Int = 1
    
    var timer: Timer? = nil
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var counter = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        // recall a SKView can show one or more SKScenes
        // this method is like viewDidLoad()
        // its called when the view "moves to" this scene
        // put init code
        
        self.addChild(cam)
        camera = cam
        cam.position.x = 0
        cam.position.y = 69
        print(camera.debugDescription)
        
        
        print("Frame width: \(self.frame.width) height: \(self.frame.height)")
        print("maxX: \(self.frame.maxX) minX: \(self.frame.minX)")
        print("maxY: \(self.frame.maxY) minY: \(self.frame.minY)")
        print("midX: \(self.frame.midX) midY: \(self.frame.midY)")
        startGame()
        
    }
    
    func startGame(){
        self.removeAllChildren()
        removeAllChildren()
        score = 0
        initGround(map_number: 1)
        initSky(sky_number: 1)
        initGuy()
        initGameOverImage()
        initFinishLine()
        if let vc = viewController {
            if vc.music {
                initAudio()
            }
        }
        startTimer()
        print("harasdfasdf")
    }
    
    func initAudio() {
        let backgroundSound = SKAudioNode(fileNamed: "miiRemix.mp3")
        self.addChild(backgroundSound)
    }
    
    func initGuy(){
        
        let guyTexture = SKTexture(imageNamed: "guy.png") // define a texture that holds our guy
        let guyNode = SKSpriteNode(texture: guyTexture) // make a new guy node
        guyNode.physicsBody = SKPhysicsBody(circleOfRadius: max(guyNode.size.width / 2, guyNode.size.height / 2)) // this creates a circular physics collision 'bubble' around *ourguy*
        guyNode.physicsBody = SKPhysicsBody(texture: guyTexture, size: CGSize(width: guyNode.size.width, height: guyNode.size.height))
        
        guyNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: guyNode.size.width / 1.2, height: guyNode.size.height / 1.5), center: CGPoint(x: 0, y: 10))
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
        physicsWorld.add(front_pin)
        
        let rear_pin = SKPhysicsJointPin.joint(withBodyA: guyNode.physicsBody!, bodyB: rearWheelNode.physicsBody!, anchor: rear_pin_anchor)
        physicsWorld.add(rear_pin)
        
        
        let rotate = SKAction.rotate(byAngle: -3000, duration: 40)
        //rearWheelNode.run(rotate)
        
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
        
        let GroundNode2 = SKSpriteNode(texture: GroundTexture)
        
        GroundNode2.physicsBody = SKPhysicsBody(texture: GroundTexture, size: CGSize(width: circularGround.size.width, height: circularGround.size.height))
        GroundNode2.physicsBody?.usesPreciseCollisionDetection = true
        GroundNode2.physicsBody?.restitution = 0.2
        //GroundNode.physicsBody?.collisionBitMask = 2
        GroundNode2.physicsBody?.categoryBitMask = 4
        GroundNode2.physicsBody?.isDynamic = false
        GroundNode2.physicsBody?.friction = 1
        GroundNode2.position = CGPoint(x: 5900, y: -300)
        self.addChild(GroundNode2)
        
        
        
    }
    
    func initSky(sky_number: Int) -> Void{
        
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: 8000, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: 8000, height: frame.height * 0.44))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: 450)
        
        self.addChild(topSky)
        self.addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
        
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: -500)
        scoreLabel.zPosition = 4
        addChild(scoreLabel)
    }
    
    func initGameOverImage(){
        gameOverImage = SKSpriteNode(imageNamed: "gameoversmall")
        gameOverImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverImage.size = CGSize(width: 200, height: 200)
        gameOverImage.zPosition = 1
        gameOverImage.isHidden = true
        addChild(gameOverImage)
        
        gameWinImage = SKSpriteNode(imageNamed: "champion")
        gameWinImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameWinImage.size = CGSize(width: 200, height: 200)
        gameWinImage.zPosition = 1
        gameWinImage.isHidden = true
        addChild(gameWinImage)
        
    }
    
    func startTimer() {
        // now we want to add the flying basketballs
        // task: add a timer that every 3 seconds
        // calls a function addBall()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.counter += 1
            self.score += 1
            
        })
    }
    
    func initFinishLine(){
        let FinishLineTexture = SKTexture(imageNamed: "finishline")
        
        let circfinishLine = SKSpriteNode(texture: FinishLineTexture)
        circfinishLine.physicsBody = SKPhysicsBody(circleOfRadius: max(circfinishLine.size.width / 2, circfinishLine.size.height / 2))
        
        let FinishLineNode = SKSpriteNode(texture: FinishLineTexture)
        
        FinishLineNode.physicsBody = SKPhysicsBody(texture: FinishLineTexture, size: CGSize(width: circfinishLine.size.width, height: circfinishLine.size.height))
        FinishLineNode.physicsBody?.usesPreciseCollisionDetection = true
        FinishLineNode.physicsBody?.restitution = 0.2
        //GroundNode.physicsBody?.collisionBitMask = 2
        FinishLineNode.physicsBody?.categoryBitMask = ColliderType.finish
        FinishLineNode.physicsBody?.isDynamic = false
        FinishLineNode.physicsBody?.friction = 1
        FinishLineNode.position = CGPoint(x: finishPosition, y: 0)
        self.addChild(FinishLineNode)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewController?.setting == "Extreme" {
            diffculty_rating = diffculty_rating * 2
        }
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        rearWheelNode.physicsBody?.applyTorque(CGFloat(-20 * diffculty_rating))
        //rearWheelNode.physicsBody?.applyForce(CGVector(dx: 0, dy: 1000))
        // print(rearWheelNode.physicsBody?.allContactedBodies())
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
        cam.position.x = rearWheelNode.position.x
        scoreLabel.position.x = rearWheelNode.position.x

        print(rearWheelNode.position)
        
        if rearWheelNode.position.y < -300{
            loseGame()
        }
        
        if Int(rearWheelNode.position.x) > finishPosition{
            print(rearWheelNode.position.x)
            print(FinishLineNode.position.x)
            
            winGame()
            
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2 {
            print("We have contact with the ground")
            
        }
        else if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            print("Collision with guy")
            loseGame()
            
        }
        else if contact.bodyA.categoryBitMask == 8 || contact.bodyB.categoryBitMask == 8 {
            // print("Collision with finish Line")
            // winGame()
            
        }
        
    }
    
    func winGame(){
        gameWinImage.position = CGPoint(x: rearWheelNode.position.x, y: self.frame.midY)
        gameWinImage.isHidden = false
        timer?.invalidate()
        isPaused = true
        
        if let myView = viewController {
            print("nice")
            myView.time = self.score
            myView.winner()
        }
    }
    
    func loseGame(){
        gameOverImage.position = CGPoint(x: rearWheelNode.position.x, y: self.frame.midY)
        let gameoverSound = SKAction.playSoundFileNamed("jazzmusic.mp3", waitForCompletion: false)
        gameOverImage.run(gameoverSound)
        gameOverImage.isHidden = false
        timer?.invalidate()
        isPaused = true
        
        
        if let myView = viewController {
            print("in the if")
            myView.loser()
        }
    }
}



/*
 
 ⁃    Added collision with rider, calls EndGame()
 ⁃    rider 'hitbox' is a rectangle a little bit smaller than he is, so that the game won’t end if a rider gets stuck on a rock.
 ⁃    Endgame Function
 ⁃    Pauses the Screen
 ⁃    Creates a "Game Over" sprite when the rider dies
 ⁃    Tries to play a sound, doesn’t work
 ⁃    Added a bunch of sounds, not really sure how to use them
 ⁃    Added a second ground node, so the track is twice as long
 ⁃    of note, sprites can only be 4096 x 4096 or the gpu won’t load them
 ⁃
 
 */
