//
//  ColladaHelper.swift
//  DiceTest1
//
//  Created by David Sadler on 7/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import SceneKit

struct ColladaHelper {
    
    enum DiceTextures: Int {
        case red
        case white
        case black
        case whiteAndGreen
        case navyAndOrange
        case emeraldAndGold
    }
    
    static func colladaToSCNNode(filepath:String) -> SCNNode {
        var node = SCNNode()
        let selectedTexturePack = UserDefaults.standard.integer(forKey: Keys.selectedDiceTexturePack)
        let scene = SCNScene(named: filepath)
        let nodeArray = scene!.rootNode.childNodes
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
                #warning("Here is where you can set the image of the customDice")
            switch selectedTexturePack {
                case DiceTextures.white.rawValue:
                switch filepath {
                    case Keys.customTetrahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d4")
                    case Keys.customCube:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d6")
                    case Keys.customOctahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d8")
                    case Keys.customD10:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d10")
                    case Keys.customD00:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d00")
                    case Keys.customDodecahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d12")
                    case Keys.customIcosahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "white_d20")
                    default:
                    print("defaulting in white dice textures")
                }
                case DiceTextures.black.rawValue:
                switch filepath {
                    case Keys.customTetrahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d4")
                    case Keys.customCube:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d6")
                    case Keys.customOctahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d8")
                    case Keys.customD10:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d10")
                    case Keys.customD00:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d00")
                    case Keys.customDodecahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d12")
                    case Keys.customIcosahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "black_d20")
                    default:
                    print("defaulting in black dice textures")
                }
                case DiceTextures.whiteAndGreen.rawValue:
                switch filepath {
                    case Keys.customTetrahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d4")
                    case Keys.customCube:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d6")
                    case Keys.customOctahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d8")
                    case Keys.customD10:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d10")
                    case Keys.customD00:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d00")
                    case Keys.customDodecahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d12")
                    case Keys.customIcosahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "whiteAndGreen_d20")
                    default:
                    print("defaulting in black dice textures")
                }
                case DiceTextures.navyAndOrange.rawValue:
                switch filepath {
                    case Keys.customTetrahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d4")
                    case Keys.customCube:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d6")
                    case Keys.customOctahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d8")
                    case Keys.customD10:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d10")
                    case Keys.customD00:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d00")
                    case Keys.customDodecahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d12")
                    case Keys.customIcosahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "navyAndOrange_d20")
                    default:
                    print("defaulting in black dice textures")
                }
                case DiceTextures.emeraldAndGold.rawValue:
                switch filepath {
                    case Keys.customTetrahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d4")
                    case Keys.customCube:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d6")
                    case Keys.customOctahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d8")
                    case Keys.customD10:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d10")
                    case Keys.customD00:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d00")
                    case Keys.customDodecahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d12")
                    case Keys.customIcosahedron:
                    childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "emeraldAndGold_d20")
                    default:
                    print("defaulting in black dice textures")
                }
                default:
                print("defaulting in colladaToSCNNode - using default texture (red)")
            }
            //childNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "D10_marble")
        }
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape())
        node.physicsBody?.angularDamping = 0.5
        node.physicsBody?.restitution = 0.3
        return node
    }
}

