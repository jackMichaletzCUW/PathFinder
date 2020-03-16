//
//  Core.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/14/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa

class Core: NSObject {

    static let PXWIDTH = 600
    static let PXHEIGHT = 600
    
    static let TILEWIDTH = 60
    static let TILEHEIGHT = 60
    
    static var stage:Int = 0
    
    static var origin:[Int] = [-1, -1]
    static var terminus:[Int] = [-1, -1]
    
    static var map = Map()
    
    static var simulation:SimView? = nil
    
    static func repaint() -> Void {
        simulation?.repaint()
    }
    
    static func cycleStage() -> Int {
        stage = (stage + 1) % 3
        return stage
    }
}
