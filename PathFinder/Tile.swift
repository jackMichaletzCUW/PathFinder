//
//  Tile.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/14/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa

class Tile: NSObject {

    public var parent:Tile?
    
    public var gval:Double = -1
    public var hval:Double = -1
    public var fval:Double = -1
    
    public enum TileType {
        case open, closed, unvisited, obstacle, point, path
    }
    
    private var timeVisited:Int = -1;
    private var type:TileType
    public var ix:Int
    public var iy:Int
    
    init(type:TileType, ix:Int, iy:Int) {
        self.type = type
        self.ix = ix
        self.iy = iy
    }
    
    // allowing diagonal movement.
    public func g() -> Double {
        if gval == -1 {
            if parent != nil {
                if !((abs(parent!.ix - ix) == 1) && (abs(parent!.iy - iy) == 1)) {
                    gval = parent!.g() + 1 //abs(parent!.ix - ix) + abs(parent!.iy - iy)
                } else {
                    gval = parent!.g() + sqrt(2.0)
                }
            }
            else {
                gval = 999999
            }
        }
        
        return gval
    }
    
    // manhattan distance
    public func h() -> Double {
        if hval == -1 {
            hval = sqrt(pow(Double(ix - Core.terminus[0]), 2.0) + pow(Double(iy - Core.terminus[1]), 2.0))
            //hval = abs(Double(ix - Core.terminus[0])) + abs(Double(iy - Core.terminus[1]))
        }
        
        return hval
    }
    
    public func f() -> Double {
        if fval == -1 {
            fval = g() + h()
        }
        
        return fval
    }
    
    /*public func visit(time:Int) -> Void {
        self.type = TileType.visited
        self.timeVisited = time
    }*/
    
    public func getAge(currentTime:Int) -> Int {
        return (self.timeVisited < 0 ? -1 : currentTime - self.timeVisited)
    }
    
    public func getType() -> TileType {
        return self.type
    }
    
    public func setType(type:TileType) -> Void {
        self.type = type
    }
}
