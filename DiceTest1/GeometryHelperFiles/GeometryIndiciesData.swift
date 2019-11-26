//
//  ConstantGeometryData.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

enum GeometryIndiciesData {
    static let tetrahedronIndices: [UInt16] = [
        0, 1, 2, //1
        1, 2, 3, //2
        0, 2, 3, //3
        0, 3, 1  //4
    ]
    static let tetrahedronSides: [String:String] = [
        "012": "1",
        "123": "2",
        "023": "3",
        "031": "4"
    ]
    static let octahedronIndices: [UInt16] = [
        0, 1, 2,
        2, 3, 0,
        3, 4, 0,
        4, 1, 0,
        1, 5, 2,
        2, 5, 3,
        3, 5, 4,
        4, 5, 1
    ]
    static let octahedronSides: [String:String] = [
        "012": "1",
        "230": "2",
        "340": "3",
        "410": "4",
        "152": "5",
        "253": "6",
        "354": "1",
        "451": "1",
    ]
    static let icosahedronIndices: [UInt16] = [
        11, 4, 6,
        8, 6, 4,
        8, 10, 2,
        8, 0, 10,
        11, 9, 2,
        11, 3, 9,
        10, 7, 5,
        9, 5, 7,
        6, 1, 3,
        5, 3, 1,
        4, 2, 0,
        7, 0, 2,
        8, 1, 6,
        8, 4, 0,
        11, 6, 3,
        11, 2, 4,
        9, 3, 5,
        9, 7, 2,
        10, 5, 1,
        10, 0, 7
    ]
    static let dodecahedronIndices: [Int32] = [
        // face 1
        8, 12, 0,
        8, 10, 3,
        8, 3, 12,
        // 2
        10, 14, 6,
        10, 8, 2,
        10, 2, 14,
        // 3
        11, 13, 4,
        11, 9, 7,
        11, 7, 13,
        // 4
        9, 15, 5,
        9, 11, 1,
        9, 1, 15,
        // 5
        15, 16, 1,
        15, 12, 0,
        15, 0, 16,
        // 6
        12, 16, 1,
        12, 15, 5,
        12, 5, 18,
        // 7
        13, 17, 5,
        13, 14, 6,
        13, 6, 17,
        // 8
        14, 19, 2,
        14, 13, 4,
        14, 4, 19,
        // 9
        16, 8, 0,
        16, 19, 2,
        16, 2, 8,
        // 10
        19, 11, 4,
        19, 16, 1,
        19, 1, 11,
        // 11
        18, 9, 5,
        18, 17, 6,
        18, 6, 9,
        // 12
        17, 10, 6,
        17, 18, 3,
        17, 3, 10
    ]
}
