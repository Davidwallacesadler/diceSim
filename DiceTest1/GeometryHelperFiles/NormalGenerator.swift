//
//  Normals.swift
//  DiceTest1
//
//  Created by David Sadler on 4/9/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct NormalGenerator {
    /// Returns the normalized cross product given three points that form vertexes for vectors U and V.
    static func calculateCrossProduct(_ a: SCNVector3, _ b: SCNVector3, _ c: SCNVector3) -> SCNVector3 {
        let vertex1 = simd_float3(a)
        let vertex2 = simd_float3(b)
        let vertex3 = simd_float3(c)
        let u = vertex2 - vertex3
        let v = vertex2 - vertex1
        let normal = simd_normalize(simd_cross(u, v))
        return SCNVector3(x: normal.x, y: normal.y, z: normal.z)
    }
}
