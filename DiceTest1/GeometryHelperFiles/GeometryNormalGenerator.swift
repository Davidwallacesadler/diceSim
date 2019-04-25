//
//  GeometryNormalGenerator.swift
//  DiceTest1
//
//  Created by David Sadler on 4/19/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct GeometryNormalGenerator {
    
    // TODO: - Fix normal calculations - Lighting is not correct for these geometies
    
    static func generateTetrahedronNormals(givenVertices: [SCNVector3]) -> [SCNVector3] {
        let normals: [SCNVector3] = [
           NormalGenerator.calculateCrossProduct(givenVertices[0], givenVertices[1], givenVertices[2]),
           NormalGenerator.calculateCrossProduct(givenVertices[1], givenVertices[2], givenVertices[3]),
           NormalGenerator.calculateCrossProduct(givenVertices[0], givenVertices[2], givenVertices[3]),
           NormalGenerator.calculateCrossProduct(givenVertices[0], givenVertices[3], givenVertices[1])
        ]
        return normals
    }
    
    static func generatOctahedronNormals(givenVertices: [SCNVector3]) -> [SCNVector3] {
        let normals: [SCNVector3] = [
            NormalGenerator.calculateCrossProduct(givenVertices[0], givenVertices[1], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[2], givenVertices[3], givenVertices[0]),
            NormalGenerator.calculateCrossProduct(givenVertices[3], givenVertices[4], givenVertices[0]),
            NormalGenerator.calculateCrossProduct(givenVertices[4], givenVertices[1], givenVertices[0]),
            NormalGenerator.calculateCrossProduct(givenVertices[1], givenVertices[5], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[2], givenVertices[5], givenVertices[3]),
            NormalGenerator.calculateCrossProduct(givenVertices[3], givenVertices[5], givenVertices[4]),
            NormalGenerator.calculateCrossProduct(givenVertices[4], givenVertices[5], givenVertices[1])
        ]
        return normals
    }
    
    static func generateIcosahedronNormals(givenVertices: [SCNVector3]) -> [SCNVector3] {
        let normals: [SCNVector3] = [
            NormalGenerator.calculateCrossProduct(givenVertices[11], givenVertices[4], givenVertices[6]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[6], givenVertices[4]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[10], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[0], givenVertices[10]),
            NormalGenerator.calculateCrossProduct(givenVertices[11], givenVertices[9], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[10], givenVertices[7], givenVertices[5]),
            NormalGenerator.calculateCrossProduct(givenVertices[9], givenVertices[5], givenVertices[7]),
            NormalGenerator.calculateCrossProduct(givenVertices[6], givenVertices[1], givenVertices[3]),
            NormalGenerator.calculateCrossProduct(givenVertices[5], givenVertices[3], givenVertices[1]),
            NormalGenerator.calculateCrossProduct(givenVertices[4], givenVertices[2], givenVertices[0]),
            NormalGenerator.calculateCrossProduct(givenVertices[7], givenVertices[0], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[1], givenVertices[6]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[4], givenVertices[0]),
            NormalGenerator.calculateCrossProduct(givenVertices[11], givenVertices[6], givenVertices[3]),
            NormalGenerator.calculateCrossProduct(givenVertices[11], givenVertices[2], givenVertices[4]),
            NormalGenerator.calculateCrossProduct(givenVertices[9], givenVertices[3], givenVertices[5]),
            NormalGenerator.calculateCrossProduct(givenVertices[9], givenVertices[7], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[10], givenVertices[5], givenVertices[1]),
            NormalGenerator.calculateCrossProduct(givenVertices[8], givenVertices[10], givenVertices[2]),
            NormalGenerator.calculateCrossProduct(givenVertices[10], givenVertices[0], givenVertices[7])
        ]
        return normals
    }
}
