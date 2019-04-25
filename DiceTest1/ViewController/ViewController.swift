//
//  ViewController.swift
//  DiceTest1
//
//  Created by David Sadler on 4/8/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//
import UIKit
import SceneKit
import SpriteKit
// TODO: - NEED TO STREAMLINE SCENE SETUP - BE ABLE TO SPAWN IN AT LEAST 2 SHAPES

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    // MARK: - Internal Properties
    
    var nodeArray: [SCNNode] = []
    var diceNode = SCNNode()
    var dice2Node = SCNNode()
    let randomX = Float.random(in: -6.0...6.0)
    let randomY = Float.random(in: 10.0...18.0)
    let randomZ = Float.random(in: 5.0...10.0)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Scene
     
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        let scene = SCNScene()
        sceneView.scene = scene
//        sceneView.allowsCameraControl = true
//        sceneView.defaultCameraController.interactionMode = .orbitTurntable
//        sceneView.scene?.physicsWorld.contactDelegate = self
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0,-20,0)

        // MARK: - Camera
        
        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(Float(90.0))
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // MARK: - Lights
        
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 10, y: 5, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // MARK: - HUD
        
        sceneView.overlaySKScene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        sceneView.overlaySKScene?.isHidden = false
        sceneView.overlaySKScene?.scaleMode = SKSceneScaleMode.resizeFill
        sceneView.overlaySKScene?.isUserInteractionEnabled = true
        let diceNumber = SKLabelNode(text: "#")
        diceNumber.fontColor = UIColor.red
        diceNumber.fontSize = 45
        diceNumber.position = CGPoint(x: (view.frame.width / 2.0), y: 10.0)
        sceneView.overlaySKScene?.addChild(diceNumber)
        
        let resetButton = UIButton(frame: CGRect(x: 35 , y: view.frame.height - 100, width: 100, height: 50.0))
        resetButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        resetButton.setTitle("Reset", for: .normal)
        sceneView.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchDown)
        
        let reRollButton = UIButton(frame: CGRect(x: 180 , y: view.frame.height - 100, width: 100.0, height: 50.0))
        reRollButton.backgroundColor = #colorLiteral(red: 0.01496514957, green: 0.4769831896, blue: 0.9854087234, alpha: 1)
        reRollButton.setTitle("Roll!", for: .normal)
        sceneView.addSubview(reRollButton)
        reRollButton.addTarget(self, action: #selector(reRollButtonClicked), for: .touchDown)
        
        // MARK: - Room Container
        
        let roomContainer = Container(x: 21.5, y: 21.5, z: 21.5)
        let roomContainerNodeArray = ContainerController.shared.createContainerPlaneNodes(container: roomContainer)
        let floorGeometryIndex = roomContainerNodeArray.endIndex - 1
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIImage(named: "marble")
        var floorMaterials = [SCNMaterial]()
        floorMaterials.append(floorMaterial)
        roomContainerNodeArray[floorGeometryIndex].geometry?.materials = floorMaterials
        
        // MARK: - Dice Contanier
        
        let diceContainer = Container(x: 7.5, y: 7.5, z: 7.5)
        let diceContainerNodeArray = ContainerController.shared.createContainerPlaneNodes(container: diceContainer)
        for node in diceContainerNodeArray {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.5)
        }
        nodeArray = diceContainerNodeArray

        // MARK: - Cubes
        
        let cubeGeometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        let cubeNode = SCNNode(geometry: cubeGeometry)
        MaterialsGenerator.generateMaterialsArray(givenGeometryKey: Keys.cubeName, targetNode: cubeNode)
        PhysicsHelper.setupDynamicNodePhysics(selectedNode: cubeNode, bitMaskKey: Keys.cubeName)
        diceNode = cubeNode
       
        let cube2Geometry = SCNBox(width: 2.0, height: 2.0, length: 2.0, chamferRadius: 0.0)
        let cube2Node = SCNNode(geometry: cube2Geometry)
        MaterialsGenerator.generateMaterialsArray(givenGeometryKey: Keys.cubeName, targetNode: cube2Node)
        PhysicsHelper.setupDynamicNodePhysics(selectedNode: cube2Node, bitMaskKey: Keys.tetrahedronName) // FIGURE OUT A WAY OF SETTING UP MULTIPLE SHAPES CATAGORY BITMASKS
        dice2Node = cube2Node
        
        // MARK: - Tetrahedron
        
//        let tetrahedronData = GeometryController.shared.initializeGeometry(givenVertices: GeometryVertexGenerator.generateTetrahedronVertices(size: GeometryParameters.shared.tetrahedronSize), givenIndices: GeometryIndiciesData.tetrahedronIndices, givenNormals: nil)
//        let tetrahedronNode = NodeGenerator.createNodeGivenGeometry(tetrahedronData)
//        PhysicsHelper.setupDynamicNodePhysics(selectedNode: tetrahedronNode, bitMaskKey: Keys.tetrahedronName)
    
        // MARK: - Camera To Geometry Constraints
        
       let constraint = SCNLookAtConstraint(target: cubeNode)
//        let distanceContstraint = SCNDistanceConstraint(target: cubeNode)
//        distanceContstraint.maximumDistance = CGFloat(integerLiteral: 5)
//        distanceContstraint.minimumDistance = CGFloat(integerLiteral: 3)

        constraint.isGimbalLockEnabled = true
        var constraints = [SCNConstraint]()
        constraints.append(constraint)
        //constraints.append(distanceContstraint)
        cameraNode.constraints = constraints
  
        // MARK: - Add Geometry Nodes
    
        for node in diceContainerNodeArray {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: node, atPosition: SCNVector3(0,0,0))
        }
        for node in roomContainerNodeArray {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: node, atPosition: SCNVector3(0,0,0))
        }
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: cubeNode, atPosition: SCNVector3(0,0,0))
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: cube2Node , atPosition: SCNVector3(2,0,0))
        //GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: tetrahedronNode, atPosition: SCNVector3(10,10,10))
        }
    
    // MARK: - Actions
    
    // TODO: - Make function: place dice back at intial position, reset the catagory and collision bit masks for the plane nodes, reset the texture.
   @objc func resetButtonClicked(_ sender: UIButton!) {
    print("Reset Tapped")
        diceNode.position = SCNVector3(0,0,0)
        diceNode.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
        dice2Node.position = SCNVector3(2,0,0)
        dice2Node.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
    for node in nodeArray {
        PhysicsHelper.setupKineticNodePhysics(containerNode: node)
        node.geometry?.firstMaterial?.diffuse.contents =  UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.5)
    }
        }
    
    //TODO: - Make funcion: rotate plane arrays for x amount of time, change the collision and catagory bitmasks to the dice bitmask and change the first material to UIColor clear - dice will fall through with random forces.
    @objc func reRollButtonClicked(_ sender: UIButton!) {
        print("Roll Tapped")
        diceNode.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
        diceNode.physicsBody?.applyTorque(SCNVector4(1.0, 2.0, 3.0, 1.0), asImpulse: true)
        dice2Node.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
        dice2Node.physicsBody?.applyTorque(SCNVector4(1.0, 2.0, 3.0, 1.0), asImpulse: true)
        for node in nodeArray {
            node.physicsBody?.categoryBitMask = BodyType.cube.rawValue
            node.physicsBody?.collisionBitMask = BodyType.container.rawValue
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        }
    }
}
