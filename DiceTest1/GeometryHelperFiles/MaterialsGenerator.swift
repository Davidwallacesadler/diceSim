//
//  MaterialsGenerator.swift
//  DiceTest1
//
//  Created by David Sadler on 4/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct MaterialsGenerator {
    
    static func generateMaterialsArray(givenGeometryKey: String, targetNode: SCNNode) {
        var materials = [SCNMaterial]()
        var numberOfFaces: Int
        switch givenGeometryKey {
        case Keys.tetrahedronName:
            numberOfFaces = 4
        case Keys.cubeName:
            numberOfFaces = 6
        case Keys.octahedronName:
            numberOfFaces = 8
        case Keys.icosahedronName:
            numberOfFaces = 20
        case Keys.dodecahedronName:
            numberOfFaces = 30
        default:
            return
        }
        for i in 1...numberOfFaces {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "\(givenGeometryKey)\(i)")
            materials.append(material)
        }
        targetNode.geometry?.materials = materials
    }
}
