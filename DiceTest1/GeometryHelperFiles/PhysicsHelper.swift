//
//  PhysicsHelper.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

// This will contain functions that will set up physics for the scene and for objects -- set up physics body for objects, set up physics world etc.

struct PhysicsHelper {
    
    // MAKE THIS SETUP ALL PHYSICS JUST MAKE THE DYNAMIC / KINETIC / STATIC BASED ON KEY --
    // ??? IS this a good use for keys?
    static func setupDynamicNodePhysics(selectedNode: SCNNode, bitMaskKey: String) {
        
        guard let nodeGeometry = selectedNode.geometry else {
            print("Error: Found nil for the associated geometry of the selectedNode.")
            return
        }
        let physicsShape = SCNPhysicsShape(geometry: nodeGeometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        selectedNode.physicsBody = physicsBody
        selectedNode.physicsBody?.isAffectedByGravity = true
        selectedNode.physicsBody?.friction = 0.75
        selectedNode.physicsBody?.restitution = 0.3
        selectedNode.physicsBody?.angularDamping = 0.5
        
        switch bitMaskKey {
        case Keys.cubeName:
            selectedNode.physicsBody?.categoryBitMask = BodyType.cube.rawValue
            selectedNode.physicsBody?.collisionBitMask = BodyType.container.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
            selectedNode.physicsBody?.contactTestBitMask = BodyType.container.rawValue
            
        case Keys.tetrahedronName:
            selectedNode.physicsBody?.categoryBitMask = BodyType.tetrahedron.rawValue
            selectedNode.physicsBody?.collisionBitMask = BodyType.container.rawValue | BodyType.cube.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
             selectedNode.physicsBody?.contactTestBitMask = BodyType.container.rawValue
            
        case Keys.octahedronName:
            selectedNode.physicsBody?.categoryBitMask = BodyType.octahedron.rawValue
            selectedNode.physicsBody?.collisionBitMask = BodyType.container.rawValue | BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
            selectedNode.physicsBody?.contactTestBitMask = BodyType.container.rawValue
            
        case Keys.icosahedronName:
            selectedNode.physicsBody?.categoryBitMask = BodyType.icosahedron.rawValue
            selectedNode.physicsBody?.collisionBitMask = BodyType.container.rawValue | BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.dodecahedron.rawValue
            selectedNode.physicsBody?.contactTestBitMask = BodyType.container.rawValue
        
        case Keys.dodecahedronName:
            selectedNode.physicsBody?.categoryBitMask = BodyType.dodecahedron.rawValue
            selectedNode.physicsBody?.collisionBitMask = BodyType.container.rawValue | BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue
            selectedNode.physicsBody?.contactTestBitMask = BodyType.container.rawValue
        default:
            print("Dynamic Node Physics Error: The passed in bitMaskKey is not a member of the shape names collection.")
            return
        }
    }
    
    static func setupKineticNodePhysics(containerNode: SCNNode) {
        guard let containerGeometry = containerNode.geometry else {
            print("Static Node Physics Error: Found nil when unwrapping container node geometry.")
            return
        }
        let physicsShape = SCNPhysicsShape(geometry: containerGeometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        containerNode.physicsBody = physicsBody
        containerNode.physicsBody?.isAffectedByGravity = false
        containerNode.physicsBody?.categoryBitMask = BodyType.container.rawValue
        containerNode.physicsBody?.collisionBitMask = BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
        containerNode.physicsBody?.contactTestBitMask = BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
    }
}
