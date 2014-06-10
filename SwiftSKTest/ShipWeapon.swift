//
//  ShipWeapon.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import SpriteKit

class ShipWeapon
{
    let clipSize: Int = 100;
    
    var projectilesToFire: Projectile[];
    
    var description: String;
    var damage: Int;
    var type:String;
    var name:String;
    var defaultWeapon = "blaster"
    var fireSpeed: CFTimeInterval;
    
    init(description: String, damage: Int, type: String, name:String, fireSpeed:CFTimeInterval, projectile:Projectile)
    {
        self.description = description;
        self.damage = damage;
        self.type = type;
        self.name = name;
        self.fireSpeed = fireSpeed;
        self.projectilesToFire = Projectile[](count: clipSize, repeatedValue: projectile);
    }
}