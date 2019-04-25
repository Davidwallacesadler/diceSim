//
//  Constants.swift
//  DiceTest1
//
//  Created by David Sadler on 4/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct GeometryParameters {
    
    // MARK: - Shared instance
    
    static let shared = GeometryParameters()
    
    //MARK: - Sizing Variables
    // TODO: - make it so the user can tweak these values within some given range.
    
    var cubeSize = 2.0
    var tetrahedronSize = 2.0
    var octahedronHeight = 1.0
    var octahedronWidth = 0.5
    var icosahedronSize = 3.0
    var dodecahedronSize = 3.0
    
}
