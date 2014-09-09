//
//  Helpers.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import SpriteKit

func moveSprite(sprite:SKSpriteNode, velocity:CGPoint, dt:NSTimeInterval, location:CGPoint)
{
    var time:CGFloat = CGFloat(dt);
    var amountToMove = CGPointMake(velocity.x * time, velocity.y * time);
    
    
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}

enum fireSpeeds: CFTimeInterval{
     case Fast = 0.005,
     Medium = 0.05,
     Slow = 0.5
}
