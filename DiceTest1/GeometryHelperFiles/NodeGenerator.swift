//
//  GeometryNodeFactory.swift
//  DiceTest1
//
//  Created by David Sadler on 4/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct NodeGenerator {
    
    static func createNodeGivenGeometry(_ geometry: Geometry) -> SCNNode {
        let geometrySource = SCNGeometrySource(vertices: geometry.vertices)
        let geometryElement = SCNGeometryElement(indices: geometry.indicies, primitiveType: .triangles)
        guard let geometryNormals = geometry.normals else {
            let sceneGeometry = SCNGeometry(sources: [geometrySource], elements: [geometryElement])
            let geometryNode = SCNNode(geometry: sceneGeometry)
            geometryNode.geometry?.firstMaterial?.isDoubleSided = true
            geometryNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            return geometryNode
        }
        let normalSource = SCNGeometrySource(normals: geometryNormals)
        var sources = [SCNGeometrySource]()
        sources.append(geometrySource)
        sources.append(normalSource)
        let sceneGeometry = SCNGeometry(sources: sources, elements: [geometryElement])
        let geometryNode = SCNNode(geometry: sceneGeometry)
        geometryNode.geometry?.firstMaterial?.isDoubleSided = true
        geometryNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        return geometryNode
    }
}
