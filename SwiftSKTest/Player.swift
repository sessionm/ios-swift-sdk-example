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
    
    var sprite = SKSpriteNode(imageNamed: "Ship")
    
    var currentWeapon: ShipWeapon;
    
    var weapons = ShipWeapon[]();
    
    var movePointsPerSecond = 150.0;
    
    var targetMoveLocation: CGPoint;
    
    
    init(spriteName: String, health: Int, level: Int, withCurrentWeapon currentWeapon: ShipWeapon = ShipWeapon(description: "Initial starting weapon.", damage: 1, type: "blaster", name:"Plasma Cannon"), initialStartPosition: CGPoint)
    {
        self.health = health;
        self.level = level;
        self.currentWeapon = currentWeapon;
        self.weapons.append(currentWeapon);
        self.targetMoveLocation = initialStartPosition;
    }
    
    func Update()
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
