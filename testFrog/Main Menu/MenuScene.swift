//
//  MenuScene.swift

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {

        
        
        
        // MARK: 배경 추가 삭제
//        var background = SKSpriteNode()
//
//        background = SKSpriteNode(imageNamed: "preview-start")
//        background.position = CGPoint(x: self.size.width / 2,
//                                      y: self.size.height / 2)
//        background.zPosition = 0
//        self.addChild(background)
        
        
        
        
        // MARK: "캐롯게임" title
//        let titleLabel = SKSpriteNode(imageNamed: "titleLabel")
//        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.7)
//        titleLabel.size = CGSize(width: 280, height:  120)
//        titleLabel.zPosition = 1
//        self.addChild(titleLabel)

        
        
        // MARK: 시작 버튼 추가
        let playBtn = SKSpriteNode(imageNamed: "start")
        playBtn.name = "playButton"
        playBtn.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        playBtn.size = CGSize(width: 250, height:  90)
        playBtn.zPosition = 1
        self.addChild(playBtn)
    }
    
    
    
    
    // MARK: 터치 이벤트
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
                let nodesArray = self.nodes(at: location)
                if nodesArray.first?.name == "playButton" {
                    let scene = GameScene(size: self.size)
                    
                    // gamescene에서 만든 background를 전달
                    scene.background = self.background
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene)
                }
            }
        
    }
}
