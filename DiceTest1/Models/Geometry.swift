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
    var vertices: [SCNVector3]
    var indicies: [UInt16]
    var normals: [SCNVector3]? // optional for now - also need UV vectors -- TODO
    init(vertices: [SCNVector3], indicies: [UInt16], normals: [SCNVector3]?) {
        self.vertices = vertices
        self.indicies = indicies
        self.normals = normals
    }
}
