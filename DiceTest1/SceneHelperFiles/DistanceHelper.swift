//
//  DistanceHelper.swift
//  DiceTest1
//
//  Created by David Sadler on 6/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct DistanceHelper {
    static func moveNodesTogetherIfSpreadPassedThreshold(nodeA: SCNNode, nodeB: SCNNode, threshold: Float) {
        
        func absoluteValue(argValue: Float) -> Float {
            if argValue < 0 {
                return -argValue
            } else {
                return argValue
            }
        }
        // only check x and y differenct
        let nodeAPosition = nodeA.worldPosition
        let nodeBPosition = nodeB.worldPosition
        
//        let deltaX = absoluteValue(argValue: (nodeAPosition.x - nodeBPosition.x))
//        let deltaY = absoluteValue(argValue: (nodeAPosition.y - nodeBPosition.y))
//
        let distance = simd_distance(simd_float3(nodeAPosition), simd_float3(nodeBPosition))
        if distance > threshold {
            guard let nodeAPhysicsBody = nodeA.physicsBody, let nodeBPhysicsBody = nodeB.physicsBody else { return }
            let physicsField = SCNPhysicsField.linearGravity()
            physicsField.direction = nodeAPosition
            nodeBPhysicsBody.charge = -0.6
            nodeB.physicsField = physicsField
        }
    }
}
