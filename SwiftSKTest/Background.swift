//
//  Background.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import SpriteKit

class Background {
    
    var bgSize: CGSize;
    var sprite: SKSpriteNode;
    
    init(size:CGSize, name: String)
    {
        self.bgSize = size;
        self.sprite = SKSpriteNode(imageNamed: name);
    }
    
}
