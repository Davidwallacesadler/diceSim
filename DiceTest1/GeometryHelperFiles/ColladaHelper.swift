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
//        if filepath == Keys.customCube {
//            let cubeGeometry = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0)
//            let cubeNode = SCNNode(geometry: cubeGeometry)
//            MaterialsGenerator.generateMaterialsArray(givenGeometryKey: Keys.cubeName, targetNode: cubeNode)
//            PhysicsHelper.setupDynamicNodePhysics(selectedNode: cubeNode, bitMaskKey: Keys.cubeName)
//            node = cubeNode
//        } else {
            let scene = SCNScene(named: filepath)
            let nodeArray = scene!.rootNode.childNodes
            for childNode in nodeArray {
                node.addChildNode(childNode as SCNNode)
                #warning("Here is where you can set the image of the customDice")
            //childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "D10_marble")
            }
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape())
            node.physicsBody?.angularDamping = 0.5
            node.physicsBody?.restitution = 0.3
       // }
        return node
    }
}

