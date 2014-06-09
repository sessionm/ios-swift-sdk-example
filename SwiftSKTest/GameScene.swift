//
//  GameScene.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var player = Player(spriteName: "Ship", health: 100, level: 1, withCurrentWeapon: ShipWeapon(description: "Blaster Cannon", damage: 1, type: "Blaster Cannon", name: "Blaster Cannon"), initialStartPosition: CGPoint(x: 100, y: 100));
    
    
    var lastUpdateTime:NSTimeInterval = 0;
    var dt:NSTimeInterval = 0;

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
        
        //var background = Background(size: UIScreen.mainScreen().bounds.size, name: "Trees1280");
        var waterColor = Background(size: self.size, name:"Watercolor1280");
        var background = Background(size: self.size, name:"Trees1280");
        
        waterColor.sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
        background.sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //self.addChild(waterColor.sprite);
        //self.addChild(background.sprite);
        
        player.sprite.xScale = 0.5;
        player.sprite.yScale = 0.5;
        
        self.addChild(player.sprite);
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            player.targetMoveLocation = location;
            if (!player.playerHasMoved)
            {
                player.playerHasMoved = true;
            }
           
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            player.targetMoveLocation = location;
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (lastUpdateTime != 0)
        {
            dt = currentTime - lastUpdateTime;
        }
        else
        {
            lastUpdateTime = currentTime;
        }
        //println("\(dt * 1000) milliseconds since last update");
        
        player.Update();
        
        if (player.playerHasMoved)
        {
            if (!player.playerMoveAchievement)
            {
                player.playerMoveAchievement = true;
                SessionM.sharedInstance().logAction("MovePlayer");
                
            }
        }
        
        if (SessionM.sharedInstance().user.unclaimedAchievementCount > 0)
        {
            //var achievementActivity: SMActivityType = SMActivityTypeAchievement;
            //SessionM.sharedInstance().presentActivity(achievementActivity);
            //println(SessionM.sharedInstance().user.unclaimedAchievementCount);
        }
        
        if (SessionM.sharedInstance().currentActivity)
        {
            println("SessionM is currently doing \(SessionM.sharedInstance().currentActivity)");
        }
        
        
    }
}
