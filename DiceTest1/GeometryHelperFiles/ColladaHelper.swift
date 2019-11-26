//
//  ColladaHelper.swift
//  DiceTest1
//
//  Created by David Sadler on 7/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct ColladaHelper {
    
    static func colladaToSCNNode(filepath:String) -> SCNNode {
        var node = SCNNode()
        let scene = SCNScene(named: filepath)
        var nodeArray = scene!.rootNode.childNodes
        
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
        }
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape())
        node.physicsBody?.angularDamping = 0.5
        node.physicsBody?.restitution = 0.1
        return node
    }
}

