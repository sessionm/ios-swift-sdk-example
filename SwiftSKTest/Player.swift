//
//  Player.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import SpriteKit

class Player
{
    var health = 100;
    var level = 1;
    
    var sprite = SKSpriteNode(imageNamed: "Ship");
    
    var movePointsPerSecond = 150.0;
    
    var targetMoveLocation: CGPoint;
    
    var playerMoveAchievement = false;
    var playerHasMoved = false;
    
    var lastTimePlayerShot: CFTimeInterval = 0;
    var playerCanShoot = false;
    
    init(spriteName: String, health: Int, level: Int, initialStartPosition: CGPoint)
    {
        self.health = health;
        self.level = level;
        self.targetMoveLocation = initialStartPosition;
    }
    
    func Update(currentTime: CFTimeInterval)
    {
        move(self, location: targetMoveLocation);
    }
    
    func move(player: Player, location:CGPoint)
    {
        var filter:CGFloat = 0.1; // You can fiddle with speed values
        var inverseFilter:CGFloat = 1.0 - filter;
        player.sprite.position = CGPoint(x: location.x * filter + player.sprite.position.x * inverseFilter,
            y: location.y * filter + player.sprite.position.y * inverseFilter);
    }
    
}


