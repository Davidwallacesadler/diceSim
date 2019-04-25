//
//  ShapeSpawner.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct GeometrySpawnHelper {
    
    static func removeShape(fromScene: SCNScene, geometryNode: SCNNode) {
        let dummyNode = SCNNode()
        //TODO: - research if there is a better way of removing a node.
        fromScene.rootNode.replaceChildNode(geometryNode, with: dummyNode)
    }
    
    static func spawnNodeIntoSceneAtPostion(parentScene: SCNScene, geometryNode: SCNNode, atPosition: SCNVector3?) {
        guard let position = atPosition else {
            parentScene.rootNode.addChildNode(geometryNode)
            return
        }
        geometryNode.position = position
        parentScene.rootNode.addChildNode(geometryNode)
    }
}
