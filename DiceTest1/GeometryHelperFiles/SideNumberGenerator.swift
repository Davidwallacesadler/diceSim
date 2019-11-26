//
//  SideNumberGenerator.swift
//  DiceTest1
//
//  Created by David Sadler on 6/23/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct SideNumberGenerator {
//    static func getSideNumber(forGeometry: Geometry) -> String {
//        
//    }
    /// Returns groupings of Strings containg the 3 index numbers that will form a triangle in the argument geometry. 
    static func indexTupleGenerator(forGeometry: Geometry) -> [String] {
        var start = 0
        var end = 2
        var grouping = String()
        var groupings = [String]()
        let indicies = forGeometry.indicies
        while end <= indicies.count {
            let slice = indicies[start...end]
            for number in slice {
                grouping.append("\(number)")
            }
            groupings.append(grouping)
            grouping = ""
            start = end + 1
            end += 3
        }
        return groupings
    }
    
}
