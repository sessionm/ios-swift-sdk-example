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
    
    var weapons = [ShipWeapon]();
    
    var movePointsPerSecond = 150.0;
    
    var targetMoveLocation: CGPoint;
    
    var playerMoveAchievement = false;
    var playerHasMoved = false;
    
    var lastTimePlayerShot: CFTimeInterval = 0;
    var playerCanShoot = false;
    
    init(spriteName: String, health: Int, level: Int, withCurrentWeapon currentWeapon: ShipWeapon = ShipWeapon(description: "Initial starting weapon.", damage: 1, type: "blaster", name:"Plasma Cannon", fireSpeed: fireSpeeds.Fast.toRaw(), projectile: Projectile(spriteName: "BlueBullet", type: "Bullet")), initialStartPosition: CGPoint)
    {
        self.health = health;
        self.level = level;
        self.currentWeapon = currentWeapon;
        self.weapons.append(currentWeapon);
        self.targetMoveLocation = initialStartPosition;
    }
    
    func Update(currentTime: CFTimeInterval)
    {
        move(self, location: targetMoveLocation);
        fire(self, currentTime: currentTime);
    }
    
    func move(player: Player, location:CGPoint)
    {
        var filter:CGFloat = 0.1; // You can fiddle with speed values
        var inverseFilter:CGFloat = 1.0 - filter;
        player.sprite.position = CGPoint(x: location.x * filter + player.sprite.position.x * inverseFilter,
            y: location.y * filter + player.sprite.position.y * inverseFilter);
    }
    
    func fire(player: Player, currentTime: CFTimeInterval)
    {
        for projectile: Projectile in player.currentWeapon.projectilesToFire
        {
            
                if (currentTime - lastTimePlayerShot > player.currentWeapon.fireSpeed)
                {
                    playerCanShoot = true;
                }
            
                if (playerCanShoot)
                {
                    /*
                        Implement bullet shooting
                    */
                    
                    //println("BULLET FIRED!");
                    //fire bullet
                    playerCanShoot = false;
                    lastTimePlayerShot = currentTime;
                    
                }
            
            
        }
    }
}


