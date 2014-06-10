//
//  Projectile.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile
{
    var type: String;
    var sprite: SKSpriteNode;
    var active: Bool = false;
    
    init(spriteName: String, type: String)
    {
        self.sprite = SKSpriteNode(imageNamed: spriteName);
        self.type = type;
    }
}
