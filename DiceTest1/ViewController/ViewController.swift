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
protocol SceneKitDiceDelegate {
    func updateDiceSelection(diceKind: String, diceCount: Int)
}

class ViewController: UIViewController, SCNPhysicsContactDelegate, SceneKitDiceDelegate {
    
    func updateDiceSelection(diceKind: String, diceCount: Int) {
        var diceNodes = [SCNNode]()
        self.currentDiceCount = diceCount
        switch diceKind {
            case Keys.customCube:
                selectedDiceKey = Keys.customCube
                for i in 1...diceCount {
                    if i == 1 {
                        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customCube))
                    } else {
                        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customCube))
                        guard let differentBodyType = bodyTypes[i] else { return }
                        PhysicsHelper.setupDynamicNodePhysics(selectedNode: diceNodes[i - 1], bitMaskKey: differentBodyType)
                    }
                }
            case Keys.customTetrahedron:
                selectedDiceKey = Keys.customTetrahedron
                for _ in 1...diceCount {
                    diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customTetrahedron))
                }
            case Keys.customDodecahedron:
                selectedDiceKey = Keys.customDodecahedron
                for _ in 1...diceCount {
                    diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customDodecahedron))
                }
            case Keys.customOctahedron:
                selectedDiceKey = Keys.customOctahedron
                for _ in 1...diceCount {
                    diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customOctahedron))
                }
            case Keys.customIcosahedron:
                selectedDiceKey = Keys.customIcosahedron
                for _ in 1...diceCount {
                    diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customIcosahedron))
                }
            case Keys.customD10:
                selectedDiceKey = Keys.customD10
            for _ in 1...diceCount {
                diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customD10))
            }
            default:
            return
        }
        for node in self.diceNodes {
            GeometrySpawnHelper.removeShape(fromScene: scene!, geometryNode: node)
        }
        self.diceNodes = diceNodes
        for nodeIndexPair in self.diceNodes.enumerated() {
            let zVectorComponent = nodeIndexPair.offset
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: nodeIndexPair.element, atPosition: SCNVector3(0, 0, zVectorComponent))
        }
    }
    
    
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
    let bodyTypes = [2: Keys.tetrahedronName, 3: Keys.octahedronName, 4: Keys.icosahedronName, 5: Keys.dodecahedronName]
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var diceContainerNode = SCNNode()
    var scene: SCNScene?
    let insideDiceNode = SCNNode()
    let motionManager = CMMotionManager()
    var rollTimer: Timer?
    var rollButtonPressed = false
    var diceNodes = [SCNNode]()
    var selectedDiceKey: String = Keys.customD10
    var currentDiceCount = 2
    var cameraNode: SCNNode?
    
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
        //sceneView.allowsCameraControl = true
//        sceneView.defaultCameraController.interactionMode = .orbitTurntable
//        sceneView.scene?.physicsWorld.contactDelegate = self
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0,-20,0)
        sceneView.scene?.physicsWorld.contactDelegate = self
        
        // MARK: - Camera
        
        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(Float(90.0))
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 12, y: 7, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        //self.camera = camera
        self.cameraNode = cameraNode
        
        // MARK: - Lights
        
        let light = SCNLight()
        let lightTwo = SCNLight()
        lightTwo.temperature = 3000
        light.type = SCNLight.LightType.omni
        lightTwo.type = SCNLight.LightType.omni
        lightTwo.castsShadow = true
        let lightNode = SCNNode()
        let lightTwoNode = SCNNode()
        lightNode.light = light
        lightTwoNode.light = lightTwo
        lightNode.position = SCNVector3(x: 0, y: 11, z: 0)
        lightTwoNode.position = SCNVector3(x: 0, y: 12, z: 3)
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(lightTwoNode)
        
        // MARK: - HUD
        
        sceneView.overlaySKScene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        sceneView.overlaySKScene?.isHidden = false
        sceneView.overlaySKScene?.scaleMode = SKSceneScaleMode.resizeFill
        sceneView.overlaySKScene?.isUserInteractionEnabled = true
        
        let infoButton = UIButton(frame: CGRect(x: self.view.bounds.maxX - ((self.view.bounds.maxX / 3.0) - 4.0), y: 27.0, width: (self.view.bounds.maxX / 3.0) - 4.0, height: 75.0))
        infoButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.setImage(UIImage(named: "infoButtonIcon"), for: .normal)
        infoButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: infoButton.layer, withRoundingCoefficient: 3.0)
        sceneView.addSubview(infoButton)
        
        let appSettingsButton = UIButton(frame: CGRect(x: (self.view.bounds.maxX / 3) + 2.0, y: 27.0, width: (self.view.bounds.maxX / 3) - 4.0, height: 75.0))
        appSettingsButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        appSettingsButton.imageView?.contentMode = .scaleAspectFit
        appSettingsButton.setImage(UIImage(named: "appSettingsIcon"), for: .normal)
        appSettingsButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: appSettingsButton.layer, withRoundingCoefficient: 3.0)
        sceneView.addSubview(appSettingsButton)

        let diceSelectionButton = UIButton(frame: CGRect(x: 2.0, y: 27, width:(self.view.bounds.maxX / 3) - 4.0, height: 75.0))
        diceSelectionButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        diceSelectionButton.imageView?.contentMode = .scaleAspectFit
        diceSelectionButton.setImage(UIImage(named: "diceSettingsIcon"), for: .normal)
        diceSelectionButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: diceSelectionButton.layer, withRoundingCoefficient: 3.0)
        sceneView.addSubview(diceSelectionButton)
        diceSelectionButton.addTarget(self, action: #selector(displaySlideIn(_:)), for: .touchDown)
        
        let panLeftButton = UIButton(frame: CGRect(x: 2.0, y: view.frame.height - 200.0, width: 75.0, height: 75.0))
        panLeftButton.imageView?.contentMode = .scaleAspectFit
        panLeftButton.setImage(UIImage(named: "cameraPanLeftIcon"), for: .normal)
        panLeftButton.tintColor = .white
        sceneView.addSubview(panLeftButton)
        panLeftButton.addTarget(self, action: #selector(panCameraLeft(_:)), for: .touchDown)
        
        
        let panRightButton = UIButton(frame: CGRect(x: view.frame.width - 75.0, y: view.frame.height - 200.0, width: 75.0, height: 75.0))
        panRightButton.imageView?.contentMode = .scaleAspectFit
        panRightButton.setImage(UIImage(named: "cameraPanRightIcon"), for: .normal)
        panRightButton.tintColor = .white
        sceneView.addSubview(panRightButton)
        panRightButton.addTarget(self, action: #selector(panCameraRight(_:)), for: .touchDown)
        
        let resetButton = UIButton(frame: CGRect(x: 0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 80.0))
        resetButton.backgroundColor = .clear
        resetButton.imageView?.contentMode = .scaleAspectFit
        resetButton.setImage(UIImage(named: "resetButtonIcon"), for: .normal)
        //resetButton.setTitle("Reset", for: .normal)
        sceneView.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchDown)
        resetButton.tintColor = .white
        
        let reRollButton = UIButton(frame: CGRect(x: view.frame.width / 2.0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 80.0))
        reRollButton.backgroundColor = .clear
        reRollButton.imageView?.contentMode = .scaleAspectFit
        reRollButton.setImage(UIImage(named: "rollButtonIcon"), for: .normal)
        reRollButton.tintColor = .white
        reRollButton.contentMode = .scaleAspectFit
       // reRollButton.setTitle("Roll!", for: .normal)
        sceneView.addSubview(reRollButton)
        reRollButton.addTarget(self, action: #selector(reRollButtonClicked), for: .touchDown)
        reRollButton.addTarget(self, action: #selector(stopRolling), for: .touchUpInside)
        
        // MARK: - Room Container
        let floor = SCNFloor()
        let northWall = SCNPlane(width: 50.0, height: 50.0)
        let southWall = SCNPlane(width: 50.0, height: 50.0)
        let eastWall = SCNPlane(width: 50.0, height: 50.0)
        let westWall = SCNPlane(width: 50.0, height: 50.0)
        eastWall.firstMaterial?.diffuse.contents = UIImage(named: "blur")
        eastWall.firstMaterial?.isDoubleSided = true
        westWall.firstMaterial?.diffuse.contents = UIImage(named: "blur")
        westWall.firstMaterial?.isDoubleSided = true
        southWall.firstMaterial?.diffuse.contents = UIImage(named: "blur")
        southWall.firstMaterial?.isDoubleSided = true
        northWall.firstMaterial?.diffuse.contents = UIImage(named: "blur")
        northWall.firstMaterial?.isDoubleSided = true
        floor.reflectionFalloffEnd = 10
        floor.reflectivity = 0.75
//        scene.fogStartDistance = 10.0
//        scene.fogEndDistance = 50.0
//        scene.fogColor = UIColor(red: 30/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        //floor.firstMaterial?.diffuse.
        floor.firstMaterial?.diffuse.wrapS = .repeat
        floor.firstMaterial?.diffuse.wrapT = .repeat
        floor.firstMaterial?.diffuse.contents = UIImage(named: "blackMarble")
        let floorNode = SCNNode(geometry: floor)
        let northWallNode = SCNNode(geometry: northWall)
        let southWallNode = SCNNode(geometry: southWall)
        let eastWallNode = SCNNode(geometry: eastWall)
        let westWallNode = SCNNode(geometry: westWall)
        northWallNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 1, 0)
        southWallNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 1, 0)
        floorNode.position = SCNVector3(x: 0, y: -7.45, z: 0)
        northWallNode.position = SCNVector3(x: 25 ,y: 0 ,z: 0)
        southWallNode.position = SCNVector3(x: -25 ,y: 0 ,z: 0)
        eastWallNode.position = SCNVector3(x: 0 ,y: 0 ,z: -25)
        westWallNode.position = SCNVector3(0, 0, 25)
        scene.rootNode.addChildNode(floorNode)
        scene.rootNode.addChildNode(northWallNode)
        scene.rootNode.addChildNode(southWallNode)
        scene.rootNode.addChildNode(westWallNode)
        scene.rootNode.addChildNode(eastWallNode)
//        let floor = SCNPlane(width: 15.0, height: 15.0)
//        let floorNode = SCNNode(geometry: floor)
//        PhysicsHelper.setupKineticNodePhysics(containerNode: floorNode)
//        floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "cube1")
        let roomContainer = Container(x: 10, y: 15, z: 10)
        let roomContainerParentNode = ContainerController.createContainerPlaneNodes(container: roomContainer)
        for child in roomContainerParentNode.childNodes {
            child.geometry?.firstMaterial?.fillMode = .fill
             child.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0)
        }
        
        // MARK: - Dice Contanier
        
        let diceContainer = Container(x: 5, y: 5, z: 5)
        let diceContainerParentNode = ContainerController.createDiceCupPlaneNodes(container: diceContainer)
        for child in diceContainerParentNode.childNodes {
            child.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            child.geometry?.firstMaterial?.isDoubleSided = true
        }
        diceContainerNode = diceContainerParentNode
    
        // MARK: - Initial Dice
        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: selectedDiceKey))
        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: selectedDiceKey))
        PhysicsHelper.setupDynamicNodePhysics(selectedNode: diceNodes[1], bitMaskKey: Keys.tetrahedronName)
        
  
        // MARK: - Add Geometry Nodes
        //GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: floorNode, atPosition: SCNVector3(0, 0, -14.9))
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: roomContainerParentNode, atPosition: SCNVector3().origin)
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: diceContainerParentNode, atPosition: SCNVector3().origin)
    
        // Custom Dice
        for node in diceNodes {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene, geometryNode: node, atPosition: SCNVector3().origin)
        }
        
        // MARK: - Camera To Geometry Constraints
        let constraint = SCNLookAtConstraint(target: floorNode)
        //let constraint = SCNLookAtConstraint(target: diceContainerNode)
        

        constraint.isGimbalLockEnabled = true
        //constraint.
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
                if self.rollButtonPressed {
                    let forceVector = SCNVector3(0.005, -0.005, 0.006)
                    let torqueVector = SCNVector4(self.randomX / 10.0,self.randomX / 10.0,self.randomX / 10.0,self.randomX)
                    for node in self.diceNodes {
                         node.physicsBody?.applyForce(forceVector, asImpulse: true)
                         node.physicsBody?.applyTorque(torqueVector, asImpulse: true)
                     }
                }
                //                        }
//                if let data = self.motionManager.accelerometerData {
//                    if self.rollButtonPressed {
//                        let x = data.acceleration.x
//                        let y = data.acceleration.y
//                        let z = data.acceleration.z
//                        let threshold = 0.000001
//                        //let forceVector = SCNVector3(x,y,z)
//                         //let torqueVector = SCNVector4(x,y,z,1.0)
//                        let forceVector = SCNVector3(x > threshold ? x * 10 : 0, y > threshold ? y * 10 : 0, z > threshold ? z * 10 : 0)
//                        let torqueVector = SCNVector4(x > threshold ? x * 10 : 0, y > threshold ? y * 10 : 0, z > threshold ? z * 10 : 0, 1)
//                        print("forceVector = \(forceVector)")
//                        print("torqueVector = \(torqueVector)")
//                        for node in self.diceNodes {
//                            node.physicsBody?.applyForce(forceVector, asImpulse: true)
//                            node.physicsBody?.applyTorque(torqueVector, asImpulse: true)
//                        }
//                    }
//                }
            })
            if rollTimer != nil {
                RunLoop.current.add(self.rollTimer!, forMode: RunLoop.Mode.default)
            }
        }
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
    
    private func respawnDice() {
        for node in diceNodes {
            node.removeFromParentNode()
        }
        diceNodes = []
        for i in 1...currentDiceCount {
            if selectedDiceKey == Keys.customCube {
                if i == 1 {
                   diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customCube))
               } else {
                   diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: Keys.customCube))
                   guard let differentBodyType = bodyTypes[i] else { return }
                   PhysicsHelper.setupDynamicNodePhysics(selectedNode: diceNodes[i - 1], bitMaskKey: differentBodyType)
               }
            } else {
                diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: selectedDiceKey))
            }
        }
        for node in diceNodes {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: node, atPosition: SCNVector3().origin)
        }
    }
    
    // MARK: - Actions
    
    @objc func panCameraLeft(_ sender: UIButton!) {
        guard let camera = cameraNode else { return }
        let currentPositionZInt = Int(camera.position.z)
        let currentPostionXInt = Int(camera.position.x)
        //print(camera.position)
        let currentXZPosition = (currentPostionXInt, currentPositionZInt)
        var deltaX = -1
        var deltaZ = 1
        let zeroToFive = 1...11
        let negativeFiveToZero = -11...1
        if currentXZPosition.1 == -12 {
            deltaX = 1
            deltaZ = 1
        }
        if currentXZPosition.0 == -12 {
            deltaX = 1
            deltaZ = -1
        }
        if currentXZPosition.0 == 12 {
            deltaX = -1
            deltaZ = 1
        }
        if currentXZPosition.1 == 12 {
            deltaX = -1
            deltaZ = -1
        }
        if zeroToFive.contains(currentXZPosition.0) && negativeFiveToZero.contains(currentXZPosition.1) {
            deltaX = 1
            deltaZ = 1
        }
        if negativeFiveToZero.contains(currentXZPosition.0) && negativeFiveToZero.contains(currentXZPosition.1) {
            deltaX = 1
            deltaZ = -1
        }
        if negativeFiveToZero.contains(currentXZPosition.0) && zeroToFive.contains(currentXZPosition.1) {
            deltaX = -1
            deltaZ = -1
        }
        if zeroToFive.contains(currentXZPosition.0) && zeroToFive.contains(currentXZPosition.1) {
            deltaX = -1
            deltaZ = 1
        }
        SCNTransaction.animationDuration = 0.5
        camera.localTranslate(by: SCNVector3(deltaX,0,deltaZ))
        print(camera.position)
    }
    
    @objc func panCameraRight(_ sender: UIButton!) {
        guard let camera = cameraNode else { return }
        let currentPositionZInt = Int(camera.position.z)
        let currentPostionXInt = Int(camera.position.x)
        //print(camera.position)
        let currentXZPosition = (currentPostionXInt, currentPositionZInt)
        var deltaX = -1
        var deltaZ = -1
        let zeroToFive = 1...11
        let negativeFiveToZero = -11...1
        if currentXZPosition.1 == -12 {
            deltaX = -1
            deltaZ = 1
        }
        if currentXZPosition.0 == -12 {
            deltaX = 1
            deltaZ = 1
        }
        if currentXZPosition.0 == 12 {
            deltaX = -1
            deltaZ = -1
        }
        if currentXZPosition.1 == 12 {
            deltaX = 1
            deltaZ = -1
        }
        if negativeFiveToZero.contains(currentXZPosition.0) && negativeFiveToZero.contains(currentXZPosition.1) {
            deltaX = -1
            deltaZ = 1
        }
        if negativeFiveToZero.contains(currentXZPosition.0) && zeroToFive.contains(currentXZPosition.1) {
            deltaX = 1
            deltaZ = 1
        }
        if zeroToFive.contains(currentXZPosition.0) && zeroToFive.contains(currentXZPosition.1) {
            deltaX = 1
            deltaZ = -1
        }
        SCNTransaction.animationDuration = 0.5
        camera.localTranslate(by: SCNVector3(deltaX,0,deltaZ))
        print(camera.position)
    }
    
    @objc func displaySlideIn(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "toShowSlideIn", sender: self)
    }
    
   @objc func resetButtonClicked(_ sender: UIButton!) {
        print("Reset Tapped")
        respawnDice()
        for child in diceContainerNode.childNodes {
            PhysicsHelper.setupKineticNodePhysics(containerNode: child)
            child.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0)
        }
    //self.cameraNode?.position = SCNVector3(x: -5, y: 7, z: 0)
    }
  
    @objc func reRollButtonClicked(_ sender: UIButton!) {
        rollButtonPressed = true
        print("Roll Tapped")
        applyMotion()
    }
    
    @objc func stopRolling() {
        rollButtonPressed = false
        stopMotion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowSlideIn" {
            guard let slideInVC = segue.destination as? DiceSelectionViewController else { return }
            slideInTransitioningDelegate.direction = .bottom
            slideInVC.transitioningDelegate = slideInTransitioningDelegate
            slideInVC.modalPresentationStyle = .custom
            slideInVC.sceneKitDiceDelegate = self  
        }
    }
}
