//
//  Geometry.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

class Geometry  {
    let vertices: [SCNVector3]
    let indicies: [UInt16]
    let normals: [SCNVector3]? // optional for now - also need UV vectors -- TODO
    let sideInfo: [String:String]?
    init(vertices: [SCNVector3], indicies: [UInt16], normals: [SCNVector3]?, sideInfo: [String:String]?) {
        self.vertices = vertices
        self.indicies = indicies
        self.normals = normals
        self.sideInfo = sideInfo
    }
}
