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

protocol DiceSettingsDelegate {
    func updateSpawnedDice(dicePathsAndCounds: [(String,Int)])
    func updateRoomWalls(shouldUpdate: Bool)
    func updateRoomFloor(shouldUpdate: Bool)
}

enum WallTextures: Int {
    case twilight
    case seafoam
    case sky
}

enum FloorTextures: Int {
    case blackMarble
    case whiteMarble
    case wood
}

class ViewController: UIViewController, SCNPhysicsContactDelegate, DiceSettingsDelegate {
    
    func updateRoomFloor(shouldUpdate: Bool) {
        if shouldUpdate {
            guard let floor = floorNode else { return }
            GeometrySpawnHelper.removeShape(fromScene: scene!, geometryNode: floor)
            setupFloor()
        }
    }
    
    func updateRoomWalls(shouldUpdate: Bool) {
        if shouldUpdate {
            guard let walls = wallNodes else { return }
            for wall in walls {
                GeometrySpawnHelper.removeShape(fromScene: scene!, geometryNode: wall)
            }
            setupWalls()
        }
    }
    
    
    func updateSpawnedDice(dicePathsAndCounds: [(String, Int)]) {
        var newDiceNodes = [SCNNode]()
        self.currentDiceNamesAndCounts = []
        for pathAndCount in dicePathsAndCounds {
            let filePath = pathAndCount.0
            let diceCount = pathAndCount.1
            for _ in 1...diceCount {
                newDiceNodes.append(ColladaHelper.colladaToSCNNode(filepath: filePath))
            }
            switch filePath {
                case Keys.customTetrahedron:
                self.currentDiceNamesAndCounts.append(("D4", diceCount))
                case Keys.customCube:
                self.currentDiceNamesAndCounts.append(("D6", diceCount))
                case Keys.customOctahedron:
                self.currentDiceNamesAndCounts.append(("D8", diceCount))
                case Keys.customD10:
                self.currentDiceNamesAndCounts.append(("D10", diceCount))
                case Keys.customD00:
                self.currentDiceNamesAndCounts.append(("D00", diceCount))
                case Keys.customDodecahedron:
                self.currentDiceNamesAndCounts.append(("D12", diceCount))
                case Keys.customIcosahedron:
                self.currentDiceNamesAndCounts.append(("D20", diceCount))
                default:
                print("ERROR: Passed in filePath in updateSpawnedDice in VC is Defaulting - no resulting tracking of the dice")
            }
        }
        for node in self.diceNodes {
            GeometrySpawnHelper.removeShape(fromScene: scene!, geometryNode: node)
        }
        self.diceNodes = newDiceNodes
        for nodeIndexPair in self.diceNodes.enumerated() {
            let zVectorComponent = nodeIndexPair.offset
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: nodeIndexPair.element, atPosition: SCNVector3(0, 0, zVectorComponent))
        }
    }

    
    // MARK: - Internal Properties

    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var scene: SCNScene?
    var sceneView: SCNView?
    let insideDiceNode = SCNNode()
    let motionManager = CMMotionManager()
    var rollTimer: Timer?
    var rollButtonPressed = false
    var diceNodes = [SCNNode]()
    var selectedDiceKey: String = Keys.customD10
    var cameraNode: SCNNode?
    var cameraLookAtNode: SCNNode?
    var floorNode: SCNNode?
    var wallNodes: [SCNNode]?
    var currentDiceNamesAndCounts = [("D10", 2)]
    
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
        setupSceneAndWorldPhysics()
        setupWalls()
        setupFloor()
        spawnClippingRoom()
        setupCamera()
        setupLights()
        setupHUDButtons()
        spawnInitialDice()
    }
    
    // MARK: - Internal Methods
    
    private func setupSceneAndWorldPhysics() {
        let sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0,-20,0)
        sceneView.scene?.physicsWorld.contactDelegate = self
        self.scene = scene
        self.sceneView = sceneView
    }
    
    private func setupCamera() {
        guard let currentScene = scene else { return }
        let camera = SCNCamera()
        camera.fieldOfView = CGFloat(Float(90.0))
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 12, y: 7, z: 0)
        currentScene.rootNode.addChildNode(cameraNode)
        guard let floorNode = cameraLookAtNode else { return }
        let constraint = SCNLookAtConstraint(target: floorNode)
        constraint.isGimbalLockEnabled = true
        var constraints = [SCNConstraint]()
        constraints.append(constraint)
        cameraNode.constraints = constraints
        self.cameraNode = cameraNode
    }
    
    private func setupLights() {
        guard let currentScene = scene else { return }
        let light = SCNLight()
        let lightTwo = SCNLight()
        lightTwo.temperature = 3000
        light.type = SCNLight.LightType.omni
        lightTwo.type = SCNLight.LightType.omni
        lightTwo.castsShadow = false
        let lightNode = SCNNode()
        let lightTwoNode = SCNNode()
        lightNode.light = light
        lightTwoNode.light = lightTwo
        lightNode.position = SCNVector3(x: 0, y: 11, z: 0)
        lightTwoNode.position = SCNVector3(x: 0, y: 12, z: 3)
        currentScene.rootNode.addChildNode(lightNode)
        currentScene.rootNode.addChildNode(lightTwoNode)
    }
    
    private func setupHUDButtons() {
        guard let currentSceneView = sceneView else { return }
        currentSceneView.overlaySKScene = SKScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        currentSceneView.overlaySKScene?.isHidden = false
        currentSceneView.overlaySKScene?.scaleMode = SKSceneScaleMode.resizeFill
        currentSceneView.overlaySKScene?.isUserInteractionEnabled = true
        let infoButton = UIButton(frame: CGRect(x: self.view.bounds.maxX - ((self.view.bounds.maxX / 3.0) - 4.0), y: 27.0, width: (self.view.bounds.maxX / 3.0) - 4.0, height: 75.0))
        infoButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.setImage(UIImage(named: "infoButtonIcon"), for: .normal)
        infoButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: infoButton.layer, withRoundingCoefficient: 3.0)
        currentSceneView.addSubview(infoButton)
        let appSettingsButton = UIButton(frame: CGRect(x: (self.view.bounds.maxX / 3) + 2.0, y: 27.0, width: (self.view.bounds.maxX / 3) - 4.0, height: 75.0))
        appSettingsButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        appSettingsButton.imageView?.contentMode = .scaleAspectFit
        appSettingsButton.setImage(UIImage(named: "appSettingsIcon"), for: .normal)
        appSettingsButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: appSettingsButton.layer, withRoundingCoefficient: 3.0)
        currentSceneView.addSubview(appSettingsButton)
        appSettingsButton.addTarget(self, action: #selector(settingsButtonPressed(_:)), for: .touchDown)
        let diceSelectionButton = UIButton(frame: CGRect(x: 2.0, y: 27, width:(self.view.bounds.maxX / 3) - 4.0, height: 75.0))
        diceSelectionButton.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 0, alpha: 0.2)
        diceSelectionButton.imageView?.contentMode = .scaleAspectFit
        diceSelectionButton.setImage(UIImage(named: "diceSettingsIcon"), for: .normal)
        diceSelectionButton.tintColor = .white
        ViewHelper.roundCornersOf(viewLayer: diceSelectionButton.layer, withRoundingCoefficient: 3.0)
        currentSceneView.addSubview(diceSelectionButton)
        diceSelectionButton.addTarget(self, action: #selector(displayDiceSettings(_:)), for: .touchDown)
        let panLeftButton = UIButton(frame: CGRect(x: 2.0, y: view.frame.height - 200.0, width: 75.0, height: 75.0))
        panLeftButton.imageView?.contentMode = .scaleAspectFit
        panLeftButton.setImage(UIImage(named: "cameraPanLeftIcon"), for: .normal)
        panLeftButton.tintColor = .white
        currentSceneView.addSubview(panLeftButton)
        panLeftButton.addTarget(self, action: #selector(panCameraLeft(_:)), for: .touchDown)
        let panRightButton = UIButton(frame: CGRect(x: view.frame.width - 75.0, y: view.frame.height - 200.0, width: 75.0, height: 75.0))
        panRightButton.imageView?.contentMode = .scaleAspectFit
        panRightButton.setImage(UIImage(named: "cameraPanRightIcon"), for: .normal)
        panRightButton.tintColor = .white
        currentSceneView.addSubview(panRightButton)
        panRightButton.addTarget(self, action: #selector(panCameraRight(_:)), for: .touchDown)
        let resetButton = UIButton(frame: CGRect(x: 0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 80.0))
        resetButton.backgroundColor = .clear
        resetButton.imageView?.contentMode = .scaleAspectFit
        resetButton.setImage(UIImage(named: "resetButtonIcon"), for: .normal)
        currentSceneView.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchDown)
        resetButton.tintColor = .white
        let reRollButton = UIButton(frame: CGRect(x: view.frame.width / 2.0 , y: view.frame.height - 100, width: view.frame.width / 2.0, height: 80.0))
        reRollButton.backgroundColor = .clear
        reRollButton.imageView?.contentMode = .scaleAspectFit
        reRollButton.setImage(UIImage(named: "rollButtonIcon"), for: .normal)
        reRollButton.tintColor = .white
        reRollButton.contentMode = .scaleAspectFit
        currentSceneView.addSubview(reRollButton)
        reRollButton.addTarget(self, action: #selector(reRollButtonClicked), for: .touchDown)
        reRollButton.addTarget(self, action: #selector(stopRolling), for: .touchUpInside)
    }
    
    private func setupWalls() {
        guard let currentScene = scene else { return }
        let northWall = SCNPlane(width: 60.0, height: 20.0)
        let southWall = SCNPlane(width: 60.0, height: 20.0)
        let eastWall = SCNPlane(width: 60.0, height: 20.0)
        let westWall = SCNPlane(width: 60.0, height: 20.0)
        var wallImage = UIImage(named:"twilightBackground")!
        switch UserDefaults.standard.integer(forKey: Keys.selectedWallTexturePack) {
            case WallTextures.seafoam.rawValue:
            wallImage = UIImage(named:"seafoamBackground")!
            case WallTextures.sky.rawValue:
            wallImage = UIImage(named:"skyBlueBackground")!
            default:
            print("UserDefaults switch error in setupRoomContainer -- defaulting to twilightBackground")
        }
        eastWall.firstMaterial?.diffuse.contents = wallImage
        eastWall.firstMaterial?.isDoubleSided = true
        westWall.firstMaterial?.diffuse.contents = wallImage
        westWall.firstMaterial?.isDoubleSided = true
        southWall.firstMaterial?.diffuse.contents = wallImage
        southWall.firstMaterial?.isDoubleSided = true
        northWall.firstMaterial?.diffuse.contents = wallImage
        northWall.firstMaterial?.isDoubleSided = true
        let northWallNode = SCNNode(geometry: northWall)
        let southWallNode = SCNNode(geometry: southWall)
        let eastWallNode = SCNNode(geometry: eastWall)
        let westWallNode = SCNNode(geometry: westWall)
        northWallNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 1, 0)
        southWallNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 1, 0)
        northWallNode.position = SCNVector3(x: 25 ,y: 0 ,z: 0)
        southWallNode.position = SCNVector3(x: -25 ,y: 0 ,z: 0)
        eastWallNode.position = SCNVector3(x: 0 ,y: 0 ,z: -25)
        westWallNode.position = SCNVector3(0, 0, 25)
        currentScene.rootNode.addChildNode(northWallNode)
        currentScene.rootNode.addChildNode(southWallNode)
        currentScene.rootNode.addChildNode(westWallNode)
        currentScene.rootNode.addChildNode(eastWallNode)
        wallNodes = [northWallNode,eastWallNode,southWallNode,westWallNode]
        
    }
    
    private func setupFloor() {
        guard let currentScene = scene else { return }
        let floor = SCNFloor()
        floor.reflectionFalloffEnd = 10
        floor.reflectivity = 0.75
        floor.firstMaterial?.diffuse.wrapS = .repeat
        floor.firstMaterial?.diffuse.wrapT = .repeat
        var floorImage = UIImage(named: "blackMarble")
        switch UserDefaults.standard.integer(forKey: Keys.selectedFloorTexture) {
            case FloorTextures.whiteMarble.rawValue:
            floorImage = UIImage(named: "marble-1")
            case FloorTextures.wood.rawValue:
            floorImage = UIImage(named: "wood")
            default:
            print("floor image is black marble -- defaulting")
        }
        floor.firstMaterial?.diffuse.contents = floorImage
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(x: 0, y: -7.45, z: 0)
        currentScene.rootNode.addChildNode(floorNode)
        self.floorNode = floorNode
    }
    
    private func spawnClippingRoom() {
        guard let currentScene = scene else { return }
        let roomContainer = Container(x: 10, y: 15, z: 10)
        let roomContainerParentNode = ContainerController.createContainerPlaneNodes(container: roomContainer)
        for child in roomContainerParentNode.childNodes {
            child.geometry?.firstMaterial?.fillMode = .fill
             child.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        }
        GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: currentScene, geometryNode: roomContainerParentNode, atPosition: SCNVector3().origin)
        cameraLookAtNode = floorNode
    }
    
    private func spawnInitialDice() {
        guard let currentScene = scene else { return }
        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: selectedDiceKey))
        diceNodes.append(ColladaHelper.colladaToSCNNode(filepath: selectedDiceKey))
        for node in diceNodes {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: currentScene, geometryNode: node, atPosition: SCNVector3().origin)
        }
    }
    
    private func applyMotion() {
        if UserDefaults.standard.bool(forKey: Keys.automaticDiceRolling) {
            self.rollTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: {(timer) in
                if self.rollButtonPressed {
                    let forceVector = SCNVector3(0.005, -0.005, 0.006)
                    let torqueVector = SCNVector4(self.randomX / 10.0,self.randomX / 10.0,self.randomX / 10.0,self.randomX)
                    for node in self.diceNodes {
                         node.physicsBody?.applyForce(forceVector, asImpulse: true)
                         node.physicsBody?.applyTorque(torqueVector, asImpulse: true)
                    }
                }
            })
            if rollTimer != nil {
                RunLoop.current.add(self.rollTimer!, forMode: RunLoop.Mode.default)
            }
        } else {
            if self.motionManager.isAccelerometerAvailable {
                self.motionManager.accelerometerUpdateInterval = 1.0 / 60.0
                self.motionManager.startAccelerometerUpdates()
                self.rollTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: {(timer) in
                    if self.rollButtonPressed {
                        if let data = self.motionManager.accelerometerData {
                           if self.rollButtonPressed {
                               let x = data.acceleration.x
                               let y = data.acceleration.y
                               let z = data.acceleration.z
                               let threshold = 0.000001
                               let forceVector = SCNVector3(x > threshold ? x * 10 : 0, y > threshold ? y * 10 : 0, z > threshold ? z * 10 : 0)
                               //let torqueVector = SCNVector4(x > threshold ? x * -10 : 0, y > threshold ? y * -10 : 0, z > threshold ? z * -10 : 0, 1)
                               print("forceVector = \(forceVector)")
                               //print("torqueVector = \(torqueVector)")
                               for node in self.diceNodes {
                                   node.physicsBody?.applyForce(forceVector, asImpulse: true)
                                   //node.physicsBody?.applyTorque(torqueVector, asImpulse: true)
                               }
                           }
                       }
                    }
                })
                if rollTimer != nil {
                    RunLoop.current.add(self.rollTimer!, forMode: RunLoop.Mode.default)
                }
            }
        }
    }
    
    private func stopMotion() {
        self.motionManager.stopAccelerometerUpdates()
        self.rollTimer = nil
    }
    
    
    private func respawnDice() {
        for node in diceNodes {
            GeometrySpawnHelper.spawnNodeIntoSceneAtPostion(parentScene: scene!, geometryNode: node, atPosition: SCNVector3().origin)
        }
    }
    
    // MARK: - Actions
    
    @objc func settingsButtonPressed(_ sender: UIButton!) {
        //self.performSegue(withIdentifier: "toShowDiceSettings", sender: self)
    }
    
    @objc func panCameraLeft(_ sender: UIButton!) {
        guard let camera = cameraNode else { return }
        let currentPositionZInt = Int(camera.position.z)
        let currentPostionXInt = Int(camera.position.x)
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
    
    @objc func displayDiceSettings(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "toShowDiceSettings", sender: self)
    }
    
   @objc func resetButtonClicked(_ sender: UIButton!) {
        print("Reset Tapped")
        respawnDice()
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
        if segue.identifier == "toShowDiceSettings" {
            guard let slideInVC = segue.destination as? DiceSettingsViewController else { return }
            slideInTransitioningDelegate.direction = .bottom
            slideInVC.transitioningDelegate = slideInTransitioningDelegate
            slideInVC.modalPresentationStyle = .custom
            slideInVC.delegate = self
            slideInVC.currentDiceAndCounts = currentDiceNamesAndCounts
        }
    }
}
