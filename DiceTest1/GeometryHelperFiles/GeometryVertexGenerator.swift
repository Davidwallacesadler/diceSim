//
//  GeometryData.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct GeometryVertexGenerator {
    /// Returns an array of vectors which define the vertices of a tetrahedron sized proportionally to the size number passed in.
    static func generateTetrahedronVertices(size: Double) -> [SCNVector3] {
        let vertices: [SCNVector3] = [
            SCNVector3(size, size, size),
            SCNVector3(-size, size, -size),
            SCNVector3(size, -size, -size),
            SCNVector3(-size, -size, size)
            ]
        return vertices
    }
    /// Returns an array of vectors which define the vertices of a octahedron sized proportionally to the height and width numbers passed in.
    static func generateOctahedronVertices(height: Double, width: Double) -> [SCNVector3] {
        let vertices: [SCNVector3] = [
            SCNVector3(0, height, 0),
            SCNVector3(-width, 0, width),
            SCNVector3(width, 0, width),
            SCNVector3(width, 0, -width),
            SCNVector3(-width, 0, -width),
            SCNVector3(0, -height, 0)
        ]
        return vertices
    }
    /// Returns an array of vectors which define the vertices of a icosahedron sized proportionally to the size number passed in.
    static func generateIcosahedronVertices(size: Double) -> [SCNVector3] {
        let phi = ((1.0 + sqrt(5.0)) / 2.0)
        let a = (0.5) * size
        let b = (1.0 / (2.0 * phi)) * size
        let vertices: [SCNVector3] = [
            SCNVector3(a, 0, b), //0
            SCNVector3(-a, 0, b), //1
            SCNVector3(a, 0, -b), //2
            SCNVector3(-a, 0, -b), //3
            SCNVector3(b, a, 0), //4
            SCNVector3(-b, -a, 0), //5
            SCNVector3(-b, a, 0), //6
            SCNVector3(b, -a, 0), //7
            SCNVector3(0, b, a), //8
            SCNVector3(0, -b, -a), //9
            SCNVector3(0, -b, a), //10
            SCNVector3(0, b, -a) //11
        ]
        return vertices
    }
    /// Returns an array of vectors which define the vertices of a dodecahedron sized proportionally to the size number passed in.
    static func generateDodecahedronVertices(size: Double) -> [SCNVector3] {
         let phi = ((1.0 + sqrt(5.0)) / 2.0)
        let b = ((1.0 / phi) * size)
        let c = ((2.0 - phi) * size)
        let vertices: [SCNVector3] = [
            SCNVector3(b, b, b), //0
            SCNVector3(b, b, -b), //1
            SCNVector3(b, -b, b), //2
            SCNVector3(-b, b, b), //3
            SCNVector3(b, -b, -b), //4
            SCNVector3(-b, b, -b), //5
            SCNVector3(-b, -b, b), //6
            SCNVector3(-b, -b, -b), //7
            SCNVector3(c, 0, 1), //8
            SCNVector3(-c, 0, -1), //9
            SCNVector3(-c, 0, 1), //10
            SCNVector3(c, 0, -1), //11
            SCNVector3(0, 1, c), //12
            SCNVector3(0, -1, -c), //13
            SCNVector3(0, -1, c), //14
            SCNVector3(0, 1, -c), //15
            SCNVector3(1, c, 0), //16
            SCNVector3(-1, -c, 0), //17
            SCNVector3(-1, c, 0), //18
            SCNVector3(1, -c, 0) //19
        ]
        return vertices
    }
}
// DODECAHEDRON PLANES:
//// 1
//8, 10, 3, 12, 0,
//// 2
//10, 8, 2, 14, 6,
//// 3
//11, 9, 7, 13, 4,
//// 4
//9, 11, 1, 15, 5,
//// 5
//15, 12, 0, 16, 1,
//// 6
//12, 15, 5, 18, 3,
//// 7
//13, 14, 6, 17, 5,
//// 8
//14, 13, 4, 19, 2,
//// 9
//16, 19, 2, 8, 0,
//// 10
//19, 16, 1, 11, 4,
//// 11
//18, 17, 6, 9, 5,
//// 12
//17, 18, 3, 10, 6


