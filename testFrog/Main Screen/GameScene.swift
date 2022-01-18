//
//  GameScene.swift
//  testFrog
//
//  Created by suding on 2021/12/09.
//
import SpriteKit
import GameplayKit

// MARK: 게임 상태 정의
enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
 
    // MARK: 배경 선택 
    var background = SKSpriteNode()
    
    // MARK: 배경 색깔
    var skyColor:SKColor!
    
    
    // MARK: touch touch
    var tutorial = SKSpriteNode()
    
    // MARK: 개구리 노드
    var frog = SKSpriteNode()
    
    
    
    
    
    // MARK: 점수 & 점수 node
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var scoreLabel = SKLabelNode()
    
    
    
    
    
    
    // MARK: 게임 스테이트를 인식할 gameState변수를 만들어줌
    var gameState = GameState.ready // 초기상태는 ready니까 ready상태로 초기화함
    var moving: SKNode!
    var restartBTN = SKSpriteNode()
    var startBTN = SKSpriteNode()
    
    // MARK: Sprite
    override func didMove(to view: SKView) {
        
        skyColor = SKColor(red: 243.0/255.0, green: 251.0/255.0, blue: 229.0/255.0, alpha: 0.0)
        self.backgroundColor = skyColor
        
        
        moving = SKNode()
        createFrog()
        createEnvironment()
        createScore()
        createTutorial()
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -10) 
        
    }
    
    
    
    // MARK: 점수 표현
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: self.size.width / 5, y: self.size.height - 750)
        scoreLabel.zPosition = 14
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(score)"
        addChild(scoreLabel)
    }
    
    
    
    
    // MARK: 개구리 만들기
    func createFrog() {
        frog = SKSpriteNode(imageNamed: "frog1")
        frog.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height / 2)
        frog.setScale(0.3)
        frog.zPosition = 4
        frog.physicsBody = SKPhysicsBody(circleOfRadius: frog.size.height / 2)
        frog.physicsBody?.categoryBitMask = PhysicsCategory.frog
        frog.physicsBody?.contactTestBitMask = PhysicsCategory.wallDown | PhysicsCategory.wallUp | PhysicsCategory.score
        frog.physicsBody?.collisionBitMask =  PhysicsCategory.wallDown | PhysicsCategory.wallUp | PhysicsCategory.land
        frog.physicsBody?.affectedByGravity = true
        frog.physicsBody?.isDynamic = false
        self.addChild(frog)
        
        var animationArray = [SKTexture]()
        let frogTexture = SKTextureAtlas(named: "Sprites")
//        for i in 1...frogTexture.textureNames.count {
//            animationArray.append(SKTexture(imageNamed: "frog\(i)"))
//
//
//        }
        animationArray.append(SKTexture(imageNamed: "frog1"))
        animationArray.append(SKTexture(imageNamed: "frog2"))
        let runningAnimation = SKAction.animate(with: animationArray, timePerFrame: 0.1)
        frog.run(SKAction.repeatForever(runningAnimation))
    }
    
    
    
    
    // MARK: 배경화면 만들기
    func createEnvironment() {
        
        let environmentAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = environmentAtlas.textureNamed("realGround")
        let landRepeatNum = Int(ceil(self.size.width / landTexture.size().width))
        
        for i in 0...landRepeatNum {
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = 3
            
            // 땅이라고 인지하는 시점 !!!
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size,
                                             center: CGPoint(x: land.size.width / 2, y: land.size.height / 2))
            
            land.physicsBody?.categoryBitMask = PhysicsCategory.land
            land.physicsBody?.isDynamic = false
            land.physicsBody?.affectedByGravity = false
            addChild(land)
            
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 10) // land size만큼 이동
            let moveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            land.run(SKAction.repeatForever(moveSequence))
            print(land.size.height)
        }
    
    }
    
    
    
    
    
    
    // MARK: 장애물 만들기
    func setupObstacle(wallDistance: CGFloat) {
        let environmentAtlas = SKTextureAtlas(named: "Environment")
        let obstacleDrum = environmentAtlas.textureNamed("drum")
        let obstacleTraffic = environmentAtlas.textureNamed("trafficLight")
        
        
        // MARK: 드럼통 !!! UP 통
        let obstacleUp = SKSpriteNode(texture: obstacleDrum)
        obstacleUp.zPosition = 2
        obstacleUp.physicsBody = SKPhysicsBody(rectangleOf: obstacleDrum.size())
        obstacleUp.physicsBody?.categoryBitMask = PhysicsCategory.wallUp
        obstacleUp.physicsBody?.isDynamic = false
        
        
        // MARK: 신호등
        let obstacleDown = SKSpriteNode(texture: obstacleTraffic)
        obstacleDown.zPosition = 2
        obstacleDown.physicsBody = SKPhysicsBody(rectangleOf: obstacleDrum.size())
        obstacleDown.physicsBody?.categoryBitMask = PhysicsCategory.wallUp
        obstacleDown.physicsBody?.isDynamic = false
        
        let obstacleCollision = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0.01, height: self.size.height))
        obstacleCollision.zPosition = 2
        obstacleCollision.physicsBody = SKPhysicsBody(rectangleOf: obstacleCollision.size)
        obstacleCollision.physicsBody?.categoryBitMask = PhysicsCategory.score
        obstacleCollision.physicsBody?.isDynamic = false
        obstacleCollision.name = "collision"
        
        addChild(obstacleUp)
        addChild(obstacleDown)
        addChild(obstacleCollision)
        
        let max = self.size.height * 0.3 // (화면의 높이의 30%)
        let xPos = self.size.width + obstacleUp.size.width
        let yPos = CGFloat(arc4random_uniform(UInt32(max))) + 200.0
        let endPos = self.size.width + (obstacleDown.size.width * 2)
        
        
        
        obstacleUp.setScale(0.8)
        obstacleDown.setScale(0.8)
        
        // 드럼통
        obstacleUp.position = CGPoint(x: xPos, y: yPos)
        
        // 신호등
      //  obstacleDown.position = CGPoint(x: xPos, y: obstacleDown.position.y + wallDistance + obstacleUp.size.height)
        obstacleDown.position = CGPoint(x: xPos, y: yPos + 200.0 + obstacleUp.size.height)
        obstacleCollision.position = CGPoint(x: xPos, y: self.size.height / 2)
        
        
        
        let moveAct = SKAction.moveBy(x: CGFloat(-endPos), y: 0, duration: 3)
        let moveSequence = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        
        
        obstacleUp.run(moveSequence)
        obstacleDown.run(moveSequence)
        obstacleCollision.run(moveSequence)
    
    }
    
    
    // MARK: 무한으로 생겨나줘
    func createForever(duration: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.setupObstacle(wallDistance: 400)
            
        }
        let wait = SKAction.wait(forDuration: duration)
        let actSeq = SKAction.sequence([create, wait])
        run(SKAction.repeatForever(actSeq))
    }
    
    
    func createTutorial() {
        tutorial = SKSpriteNode(imageNamed: "click")
        tutorial.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tutorial.setScale(0.58)
        tutorial.zPosition = 9
        addChild(tutorial)
    }
    
    
    
    
    
    // MARK: 터치 이벤트
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameState {
        case .ready:
            gameState = .playing
            self.frog.physicsBody?.isDynamic = true
            self.frog.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            createForever(duration: 3)
            let fadeOut = SKAction.fadeOut(withDuration: 2.0)
            let wait = SKAction.wait(forDuration: 2.0)
            let remove = SKAction.removeFromParent()
            let actSequence = SKAction.sequence([fadeOut, wait, remove])
            self.tutorial.run(actSequence)
            
        case .playing:
            self.run(SoundFx.back)
            self.frog.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            // MARK: 점프 강도
            self.frog.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
            

        case .dead:
            var animationArray = [SKTexture]()
            animationArray.append(SKTexture(imageNamed: "deadFrog"))
            animationArray.append(SKTexture(imageNamed: "deadFrog"))
            let deadAnimation = SKAction.animate(with: animationArray, timePerFrame: 0.1)
            frog.run(SKAction.repeatForever(deadAnimation))
            
            let scene = GameScene(size: self.size)
            let transition = SKTransition.doorsOpenVertical(withDuration: 1)
            self.view?.presentScene(scene, transition: transition)
            
        }
  
    }
    
    
    
    
    
    // MARK: 재시작 버튼
    func createBTN() {
       restartBTN = SKSpriteNode(imageNamed: "restart")
        restartBTN.size = CGSize(width: 300, height:  110)
        restartBTN.position = CGPoint(x: self.size.width / 2, y: self.size.height - 250)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    
    
    
    
    
    // MARK: 시작 버튼
    func createStartBTN() {
       startBTN = SKSpriteNode(imageNamed: "startButton")
        startBTN.size = CGSize(width: 300, height:  120)
        startBTN.position = CGPoint(x: self.size.width / 2, y: self.size.height - 250)
        startBTN.zPosition = 6
        startBTN.setScale(0)
        self.addChild(startBTN)
        startBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
  
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var collideBody = SKPhysicsBody() // frog가 아닌 다른 충돌 객체
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                    collideBody = contact.bodyB
                } else {
                    collideBody = contact.bodyA
                }
        
        let collideType = collideBody.categoryBitMask
  
       
        switch collideType {
        case PhysicsCategory.wallUp:
            frog = SKSpriteNode(imageNamed: "deadFrog")
            print("위에 장애물")
            gameOver()
 
        case PhysicsCategory.wallDown:
            frog = SKSpriteNode(imageNamed: "deadFrog")
            print("아래장애물")
            gameOver()
            //createBTN()
            
        case PhysicsCategory.score:
            score += 1
            print(score)
        default:
            break
        }
    }
    
    
    
    
    // MARK: 게임 오버
    func gameOver() {
        self.gameState = .dead
        //demageEffect()
        createBTN()
        frog = SKSpriteNode(imageNamed: "deadFrog")
        //self.isPaused = true
    }
    
    
    
    
    
    func demageEffect() {
        let flashNode = SKSpriteNode(color: UIColor(ciColor: .gray), size: self.size)
        let actionSequence = SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.removeFromParent()])
        flashNode.name = "flashNode"
        flashNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        flashNode.zPosition = 17
        addChild(flashNode)
        flashNode.run(actionSequence)
    }
}
