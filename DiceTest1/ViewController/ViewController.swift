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
import CoreMotion


// TODO: - NEED TO STREAMLINE SCENE SETUP - BE ABLE TO SPAWN IN AT LEAST 2 SHAPES - BREAK APART VIEW SETUP

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    // MARK: - PhysicsContactDelegate Methods
    
    
//    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        // IDEA: Check when the dice have come in contact with the container and if they are at rest we could find the orthonormal vector to the container floor; U, and calculate the cross product forthe planes of the geometry; [V]. I.E for each V Find where U Cross V = 0 (Where U || V ).
//        //contact.nodeA.physicsBody?.isResting
//       // print("Collision with floor")
//        // NODE A SEEMS TO BE WALL
//        guard let nodeBPhysicsBodyVelocity = contact.nodeB.physicsBody?.velocity else { return }
//        // JUST CHECK NODE B - SEEMS TO BE THE
////        print("NODE A: \(nodeAPhysicsBody.velocity)")
////         print("NODE B: \(nodeBPhysicsBody.velocity)")
//        let xVelocity = nodeBPhysicsBodyVelocity.x
//        let yVelocity = nodeBPhysicsBodyVelocity.y
//        let zVelocity = nodeBPhysicsBodyVelocity.z
//        let velocityThreshold: Float = 0.0000001
//        if xVelocity <= velocityThreshold && yVelocity <= velocityThreshold && zVelocity <= velocityThreshold {
//            // NOW CHECK IF THE DICE ARE FAR AWAY FROM EACHOTHER -- IF SO PULL THEM TOGETHER WITH FORCES?
//        DistanceHelper.moveNodesTogetherIfSpreadPassedThreshold(nodeA: diceNode, nodeB: dice2Node, threshold: 2.0)
//        }
//    }
    
    // MARK: - Internal Properties
    var customCubeNode = ColladaHelper.colladaToSCNNode(filepath: Keys.customOctahedron)
    var customCubeNode2 = ColladaHelper.colladaToSCNNode(filepath: Keys.customOctahedron)
    var diceContainerNode = SCNNode()
    var scene: SCNScene?
    let insideDiceNode = SCNNode()
    //var dice2Node = SCNNode()
    let motionManager = CMMotionManager()
    var rollTimer: Timer?
    var rollButtonPressed = false
    
    // MARK: - Computed Properties
    
    var randomX: Float {
        get {
             return Float.random(in: -6.0...6.0)
        }
    }
    var randomY: Float {
        get {
            return Float.random(in: 10.0...18.0)
        }
    }
    var randomZ: Float {
        get {
            return Float.random(in: 5.0...10.0)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Scene
     
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        let scene = SCNScene()
        self.scene = scene
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
//        sceneView.defaultCameraController.interactionMode = .orbitTurntable
//        sceneView.scene?.physicsWorld.contactDelegate = self
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0,-20,0)
        sceneView.scene?.physicsWorld.contactDelegate = self
        
        // MARK: - Camera
        
        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(Float(90.0))
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 7, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        // MARK: - Lights
        
        let light = SCNLight()
        let lightTwo = SCNLight()
        light.type = SCNLight.LightType.omni
        lightTwo.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        let lightTwoNode = SCNNode()
        lightNode.light = light
        lightTwoNode.light = lightTwo
        lightNode.position = SCNVector3(x: 0, y: 11, z: 0)
        lightTwoNode.position = SCNVector3().origin
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(lightTwoNode)
        
        // MARK: - HUD
        
        sceneView.overlaySKScene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        sceneView.overlaySKScene?.isHidden = false
        sceneView.overlaySKScene?.scaleMode = SKSceneScaleMode.resizeFill
        sceneView.overlaySKScene?.isUserInteractionEnabled = true
//        let diceNumber = SKLabelNode(text: "#")
//        diceNumber.fontColor = UIColor.red
//        diceNumber.fontSize = 45
//        diceNumber.position = CGPoint(x: (view.frame.width / 2.0), y: 10.0)
//        sceneView.overlaySKScene?.addChild(diceNumber)
        
        let resetButton = UIButton(frame: CGRect(x: 0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 100.0))
        resetButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        resetButton.setTitle("Reset", for: .normal)
        sceneView.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchDown)
        
        let reRollButton = UIButton(frame: CGRect(x: view.frame.width / 2.0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 100.0))
        reRollButton.backgroundColor = #colorLiteral(red: 0.01496514957, green: 0.4769831896, blue: 0.9854087234, alpha: 1)
        reRollButton.setTitle("Roll!", for: .normal)
        sceneView.addSubview(reRollButton)
        reRollButton.addTarget(self, action: #selector(reRollButtonClicked), for: .touchDown)
        reRollButton.addTarget(self, action: #selector(stopRolling), for: .touchUpInside)
        
        // MARK: - Room Container
        
        let roomContainer = Container(x: 15, y: 15, z: 15)
        let roomContainerParentNode = ContainerController.createContainerPlaneNodes(container: roomContainer)
        for child in roomContainerParentNode.childNodes {
             child.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        }
        
        // MARK: - Dice Contanier
        
        let diceContainer = Container(x: 5, y: 5, z: 5)
        let diceContainerParentNode = ContainerController.createDiceCupPlaneNodes(container: diceContainer)
        for child in diceContainerParentNode.childNodes {
            child.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.5)
        }
        diceContainerNode = diceContainerParentNode
    
        // MARK: - Cubes
        
        //customCubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        //customCubeNode2.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        let customCubeNode = ColladaHelper.colladaToSCNNode(filepath: Keys.customCube)
//        diceNode = customCubeNode
//
//        let customCubeNode2 = ColladaHelper.colladaToSCNNode(filepath: Keys.customCube)
//        dice2Node = customCubeNode2
    
        
  
        // MARK: - Add Geometry Nodes
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: roomContainerParentNode, atPosition: SCNVector3().origin)
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: diceContainerParentNode, atPosition: SCNVector3().origin)
    
        // Custom Dice
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: customCubeNode, atPosition: SCNVector3().origin)
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: customCubeNode2, atPosition: SCNVector3().origin)
        
        // MARK: - Camera To Geometry Constraints
        let constraint = SCNLookAtConstraint(target: diceContainerNode)
        //let constraint = SCNLookAtConstraint(target: insideDiceNode)

        constraint.isGimbalLockEnabled = true
        var constraints = [SCNConstraint]()
        constraints.append(constraint)
        cameraNode.constraints = constraints
        }
    
    // MARK: - Internal Methods
    
    private func applyMotion() {
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            self.motionManager.startAccelerometerUpdates()
            self.rollTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: {(timer) in
                if let data = self.motionManager.accelerometerData {
                    if self.rollButtonPressed {
                        let x = data.acceleration.x
                        let y = data.acceleration.y
                        let z = data.acceleration.z
                        let threshold = 0.0001
                        let forceVector = SCNVector3(x > threshold ? x * 10 : 0, y > threshold ? y * 10 : 0, z > threshold ? z*10 : 0)
                        let torqueVector = SCNVector4(x > threshold ? x * 10 : 0, y > threshold ? y * 10 : 0, z > threshold ? z * 10 : 0, 1)
                        print(forceVector)
                        print(torqueVector)
                        self.customCubeNode.physicsBody?.applyForce(forceVector, asImpulse: true)
                        self.customCubeNode.physicsBody?.applyTorque(torqueVector, asImpulse: true)
                        self.customCubeNode2.physicsBody?.applyForce(forceVector, asImpulse: true)
                        self.customCubeNode2.physicsBody?.applyTorque(torqueVector, asImpulse: true)
                    }
                }
            })
            if rollTimer != nil {
                RunLoop.current.add(self.rollTimer!, forMode: RunLoop.Mode.default)
            }
        }
//        let forceVector = SCNVector3(Int.random(in: 0...2), Int.random(in: 0...2), Int.random(in: 0...2))
//        let torqueVector = SCNVector4(Int.random(in: 0...3), Int.random(in: 1...2), Int.random(in: 0...1), Int.random(in: 0...2))
//        self.customCubeNode.physicsBody?.applyForce(forceVector, asImpulse: true)
//        self.customCubeNode.physicsBody?.applyTorque(torqueVector, asImpulse: true)
//        self.customCubeNode2.physicsBody?.applyForce(forceVector, asImpulse: true)
//        self.customCubeNode2.physicsBody?.applyTorque(torqueVector, asImpulse: true)
//        self.customCubeNode.physicsBody?.applyForce(forceVector, asImpulse: true)
//        self.customCubeNode.physicsBody?.applyTorque(torqueVector, asImpulse: true)
//        self.customCubeNode2.physicsBody?.applyForce(forceVector, asImpulse: true)
//        self.customCubeNode2.physicsBody?.applyTorque(torqueVector, asImpulse: true)
    }
    
    private func stopMotion() {
        self.motionManager.stopAccelerometerUpdates()
        self.rollTimer = nil
        for child in diceContainerNode.childNodes {
            child.physicsBody?.categoryBitMask = BodyType.cube.rawValue
            child.physicsBody?.collisionBitMask = BodyType.container.rawValue
            child.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        }
    }
    
    // MARK: - Actions
    
    // TODO: - Make function: place dice back at intial position, reset the catagory and collision bit masks for the plane nodes, reset the texture.
   @objc func resetButtonClicked(_ sender: UIButton!) {
    print("Reset Tapped")
//    for child in customCubeNode.childNodes {
//        GeometrySpawnHelper.removeShape(fromScene: scene!, geometryNode: child)
//    }
    customCubeNode.removeFromParentNode()
    customCubeNode2.removeFromParentNode()
    let newDice = ColladaHelper.colladaToSCNNode(filepath: Keys.customOctahedron)
    let newDice2 = ColladaHelper.colladaToSCNNode(filepath: Keys.customOctahedron)
    customCubeNode = newDice
    customCubeNode2 = newDice2
//    customCubeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
//    customCubeNode2.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
    GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: newDice, atPosition: SCNVector3(0, 0, 0))
    GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: newDice2, atPosition: SCNVector3(2, 0, 0))
//        customCubeNode.position = SCNVector3(0,0,0)
       customCubeNode.physicsBody?.clearAllForces()
//        customCubeNode.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
//        customCubeNode2.position = SCNVector3(2,0,0)
      customCubeNode2.physicsBody?.clearAllForces()
//        customCubeNode2.physicsBody?.applyForce(SCNVector3(Float.random(in: -6.0...6.0), Float.random(in: 10.0...18.0), Float.random(in: 5.0...10.0)), asImpulse: true)
    for child in diceContainerNode.childNodes {
        PhysicsHelper.setupKineticNodePhysics(containerNode: child)
        child.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.5)
    }
        }
    
    //TODO: - Make funcion: rotate plane arrays for x amount of time, change the collision and catagory bitmasks to the dice bitmask and change the first material to UIColor clear - dice will fall through with random forces.
    @objc func reRollButtonClicked(_ sender: UIButton!) {
        rollButtonPressed = true
        print("Roll Tapped")
        applyMotion()
    }
    
    @objc func stopRolling() {
        rollButtonPressed = false
        stopMotion()
    }
    
//    func gyroStuff(timer:Timer) {
//        // ACCELERATION:
//        guard let xAcceleration = motionManager.accelerometerData?.acceleration.x, let yAcceleration = motionManager.accelerometerData?.acceleration.y, let zAcceleration = motionManager.accelerometerData?.acceleration.z else { return }
//        let force = SCNVector3(10.0 * xAcceleration, 10.0 * yAcceleration, 10.0 * zAcceleration)
//        // ROTATION:
//        guard let xRotation = motionManager.deviceMotion?.rotationRate.x, let yRotation = motionManager.deviceMotion?.rotationRate.y, let zRotation = motionManager.deviceMotion?.rotationRate.z else { return }
//        let torque = SCNVector4(10.0 * xRotation, 10.0 * yRotation, 10.0 * zRotation, 0.1)
//        for node in nodeArray {
//            node.physicsBody?.applyForce(force, asImpulse: true)
//            node.physicsBody?.applyTorque(torque, asImpulse: true)
//        }
//    }
}
