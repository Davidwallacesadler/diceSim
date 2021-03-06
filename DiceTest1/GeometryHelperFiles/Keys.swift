//
//  Keys.swift
//  DiceTest1
//
//  Created by David Sadler on 4/19/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

enum Keys {
    // MARK: - 3D Model Keys (for bit mask setup - see physicsHelper)
    static let cubeName = "cube"
    static let tetrahedronName = "tetra"
    static let octahedronName = "octra"
    static let icosahedronName = "icosa"
    static let dodecahedronName = "dodeca"
    static let wallName = "wall"
    
    //MARK: - Collada SceneKitAsset Names
    static let customCube = "SceneKitAssets.scnassets/cube.scn"
    static let customTetrahedron = "SceneKitAssets.scnassets/tetrahedron.scn"
    static let customOctahedron = "SceneKitAssets.scnassets/octahedron.scn"
    static let customIcosahedron = "SceneKitAssets.scnassets/icosahedron.scn"
    static let customDodecahedron = "SceneKitAssets.scnassets/dodecahedron.scn"
    static let customD10 = "SceneKitAssets.scnassets/D10-Fixed.scn"
    static let customD00 = "SceneKitAssets.scnassets/D00.scn"
    
    // MARK: - UserDefaults Keys
    static let firstLaunch = "firstLaunch"
    static let onboarding = "onboarding"
    static let selectedDiceTexturePack = "diceTexture"
    static let selectedFloorTexture = "floorTexture"
    static let selectedWallTexturePack = "wallTexture"
    static let automaticDiceRolling = "autoDiceRoll"
}
