//
//  GameScene.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var player = Player(spriteName: "Ship", health: 100, level: 1, withCurrentWeapon: ShipWeapon(description: "Blaster Cannon", damage: 1, type: "Blaster Cannon", name: "BlasterCannon", fireSpeed: 0.05, projectile: Projectile(spriteName: "BlueBullet", type: "Bullet")), initialStartPosition: CGPoint(x: 300, y: 200));
    
    var lastUpdateTime:NSTimeInterval = 0;
    var dt:NSTimeInterval = 0;
    
    var achievementEarned = false;
    var achievementDisplayed = false;
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
    
    var achievementData = SMAchievementData();
    
    
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
        
        player.Update(currentTime);
        
        if (player.playerHasMoved)
        {
            if (!player.playerMoveAchievement)
            {
                player.playerMoveAchievement = true;
                            SessionM.sharedInstance().logAction("MovePlayer");
            }
        }
        
        //make sure the user actually has unclaimed achievements
        if (SessionM.sharedInstance().user.unclaimedAchievementCount > 0)
        {
            achievementEarned = true;
            if (achievementEarned)
            {
                if (!achievementDisplayed){
                    
                    //make sure that the Achievement has been set before assigning it, just in case
                    //My own method that returns the achievement data if it exists.
                    //Note that you must cast your AppDelegate before this step if you choose to do it this way
                    //It is a class variable that is called like this var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
                    if (SwiftSKTest.AppDelegate.getCurrentAchievement(self.appDelegate)()?)
                    {
                        // Achievement data comes from didUpdateUnclaimedAchievement achievement delgate method from the SessionM class.
                        var achievementData: SMAchievementData? = SwiftSKTest.AppDelegate.getCurrentAchievement(self.appDelegate)();
                        
                        //validate achievement data again just in case, probably don't have to do this
                        if (achievementData?)
                        {
                            //instantiate native achievement class and pass it the achievement data
                            var nativeAchievementAlert: SMAlertViewCustomAchievement = SMAlertViewCustomAchievement(theData: achievementData!);
                            //call its preset() function
                            nativeAchievementAlert.present();
                            
                            /*
                                uncomment this if you want to display non-native achievements, I managed to get it working with a full portal view
                                and by setting the Display Type in the dev portal to Native Display
                            
                            */
                            //SessionM.sharedInstance().presentActivity(SMActivityTypeAchievement);
                            
                            achievementDisplayed = true;
                        }
                    }
                }
            }
        }
        
        if (SessionM.sharedInstance().currentActivity)
        {
            //println("SessionM is currently doing \(SessionM.sharedInstance().currentActivity)");
        }
    }
    
    
    
}
