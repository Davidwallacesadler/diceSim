//
//  ContainerController.swift
//  DiceTest1
//
//  Created by David Sadler on 4/15/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

class ContainerController {
    
    // TODO: - RESEARCH SETTING A PARENT NODE FOR THE PLANE CHILD NODES - APPLY FORCES TO PARENT NODE
    
    /**
     Creates a hollow "box" geometry for containing geometry.
     
     - Parameter container: The object that defines the size values for the container such that (x: length, y: height, z: width).
     
     - Returns: Array of nodes that each have a plane geometry associated with it.
     */
    static func createContainerPlaneNodes(container: Container) -> SCNNode  {
        
            // TODO: - USE THE NEW METHOD TO MAKE SCNGEOMETRY
        func geometrySetup(vertices: [SCNVector3], element: SCNGeometryElement) -> SCNGeometry {
            let geometrySource = SCNGeometrySource(vertices: vertices)
            let geometry = SCNGeometry(sources: [geometrySource], elements: [element])
            geometry.firstMaterial?.isDoubleSided = true
            geometry.firstMaterial?.diffuse.contents = UIColor.gray
            geometry.firstMaterial?.transparencyMode = .singleLayer
            return geometry
        }
        var faces = [SCNGeometry]()
        let length = container.x / 2.0
        let height = container.y / 2.0
        let width = container.z / 2.0
        let planeIndices: [UInt16] = [
            0, 1, 2,
            2, 3, 0
        ]
        let planeElement = SCNGeometryElement(indices: planeIndices, primitiveType: .triangles)
        let rightSideVertices: [SCNVector3] = [
            SCNVector3(length, height, width),
            SCNVector3(length, -height, width),
            SCNVector3(length, -height, -width),
            SCNVector3(length, height, -width)
        ]
        let frontSideVertices: [SCNVector3] = [
            SCNVector3(-length, height, width),
            SCNVector3(-length, -height, width),
            SCNVector3(length, -height, width),
            SCNVector3(length, height, width)
        ]
        let leftSideVertices: [SCNVector3] = [
            SCNVector3(-length, -height, -width),
            SCNVector3(-length, -height, width),
            SCNVector3(-length, height, width),
            SCNVector3(-length, height, -width)
        ]
        let backSideVertices: [SCNVector3] = [
            SCNVector3(length, height, -width),
            SCNVector3(length, -height, -width),
            SCNVector3(-length, -height, -width),
            SCNVector3(-length, height, -width)
        ]
        let topSideVertices: [SCNVector3] = [
            SCNVector3(-length, height, -width),
            SCNVector3(-length, height, width),
            SCNVector3(length, height, width),
            SCNVector3(length, height, -width)
        ]
        let bottomSideVertices: [SCNVector3] = [
            SCNVector3(length, -height, width),
            SCNVector3(length, -height, -width),
            SCNVector3(-length, -height, -width),
            SCNVector3(-length, -height, width)
        ]
        faces.append(geometrySetup(vertices: rightSideVertices, element: planeElement))
        faces.append(geometrySetup(vertices: frontSideVertices, element: planeElement))
        faces.append(geometrySetup(vertices: leftSideVertices, element: planeElement))
        faces.append(geometrySetup(vertices: backSideVertices, element: planeElement))
        faces.append(geometrySetup(vertices: topSideVertices, element: planeElement))
        faces.append(geometrySetup(vertices: bottomSideVertices, element: planeElement))
        
        var containerNodeArray = [SCNNode]()
        let parentNode = SCNNode()
        for geometry in faces {
            containerNodeArray.append(SCNNode(geometry: geometry))
        }
        for node in containerNodeArray {
            parentNode.addChildNode(node)
            PhysicsHelper.setupKineticNodePhysics(containerNode: node)
        }
        return parentNode
        }
    
    static func createDiceCupPlaneNodes(container: Container) -> SCNNode  {
          
              // TODO: - USE THE NEW METHOD TO MAKE SCNGEOMETRY
      func geometrySetup(vertices: [SCNVector3], element: SCNGeometryElement) -> SCNGeometry {
          let geometrySource = SCNGeometrySource(vertices: vertices)
          let geometry = SCNGeometry(sources: [geometrySource], elements: [element])
          geometry.firstMaterial?.isDoubleSided = true
          geometry.firstMaterial?.diffuse.contents = UIColor.gray
          geometry.firstMaterial?.transparencyMode = .singleLayer
          return geometry
      }
      var faces = [SCNGeometry]()
      let length = container.x / 2.0
      let height = container.y / 2.0
      let width = container.z / 2.0
      let planeIndices: [UInt16] = [
          0, 1, 2,
          2, 3, 0
      ]
      let planeElement = SCNGeometryElement(indices: planeIndices, primitiveType: .triangles)
      let rightSideVertices: [SCNVector3] = [
          SCNVector3(length, height, width),
          SCNVector3(length, -height, width),
          SCNVector3(length, -height, -width),
          SCNVector3(length, height, -width)
      ]
      let frontSideVertices: [SCNVector3] = [
          SCNVector3(-length, height, width),
          SCNVector3(-length, -height, width),
          SCNVector3(length, -height, width),
          SCNVector3(length, height, width)
      ]
      let leftSideVertices: [SCNVector3] = [
          SCNVector3(-length, -height, -width),
          SCNVector3(-length, -height, width),
          SCNVector3(-length, height, width),
          SCNVector3(-length, height, -width)
      ]
      let backSideVertices: [SCNVector3] = [
          SCNVector3(length, height, -width),
          SCNVector3(length, -height, -width),
          SCNVector3(-length, -height, -width),
          SCNVector3(-length, height, -width)
      ]
      let topSideVertices: [SCNVector3] = [
          SCNVector3(-length, height, -width),
          SCNVector3(-length, height, width),
          SCNVector3(length, height, width),
          SCNVector3(length, height, -width)
      ]
      let bottomSideVertices: [SCNVector3] = [
          SCNVector3(length, -height, width),
          SCNVector3(length, -height, -width),
          SCNVector3(-length, -height, -width),
          SCNVector3(-length, -height, width)
      ]
      faces.append(geometrySetup(vertices: rightSideVertices, element: planeElement))
      faces.append(geometrySetup(vertices: frontSideVertices, element: planeElement))
      faces.append(geometrySetup(vertices: leftSideVertices, element: planeElement))
      faces.append(geometrySetup(vertices: backSideVertices, element: planeElement))
      faces.append(geometrySetup(vertices: topSideVertices, element: planeElement))
      faces.append(geometrySetup(vertices: bottomSideVertices, element: planeElement))
      
  let parentNode = SCNNode()
  for geometry in faces {
    let planeChildNode = SCNNode(geometry: geometry)
    let physicsShape = SCNPhysicsShape(geometry: planeChildNode.geometry!, options: nil)
    let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
    planeChildNode.physicsBody = physicsBody
    planeChildNode.physicsBody?.isAffectedByGravity = false
    planeChildNode.physicsBody?.categoryBitMask = BodyType.container.rawValue
    planeChildNode.physicsBody?.collisionBitMask = BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
    planeChildNode.physicsBody?.contactTestBitMask = BodyType.cube.rawValue | BodyType.tetrahedron.rawValue | BodyType.octahedron.rawValue | BodyType.icosahedron.rawValue | BodyType.dodecahedron.rawValue
    parentNode.addChildNode(planeChildNode)
        }
    return parentNode
    }
}





