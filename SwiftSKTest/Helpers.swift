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
    var amountToMove = CGPointMake(velocity.x * dt, velocity.y * dt);
    
    
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}

