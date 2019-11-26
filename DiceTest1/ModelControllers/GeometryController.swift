//
//  GeometryParameterController.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

class GeometryController {
    
    // MARK: - Shared Instance
    
    static let shared = GeometryController()
    
    // MARK: - CRUD
    
    func initializeGeometry(givenVertices: [SCNVector3], givenIndices: [UInt16], givenNormals: [SCNVector3]?, givenSideInfo: [String:String]?) -> Geometry {
        guard let normals = givenNormals, let sideInfo = givenSideInfo else {
            return Geometry(vertices: givenVertices, indicies: givenIndices, normals: nil, sideInfo: nil)
        }
        return Geometry(vertices: givenVertices, indicies: givenIndices, normals: normals, sideInfo: sideInfo)
    }
    
    
//    func scaleShapeByFactor(scaleFactor: Double, givenShapeKey: String) {
//        switch givenShapeKey {
//        case Keys.cubeName:
//            GeometryParameters.
//        }
//    }
}
