//
//  Simulation.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/15/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa

class Simulation: NSObject {

    static var initialized:Bool = false
    static var open:[Tile] = [Tile]()
    static var closed:[Tile] = [Tile]()
    
    static func initSim() -> Void {
        open.append(Core.map.grid[Core.origin[0]][Core.origin[1]])
        open[0].gval = 0
        open[0].fval = open[0].h()
        Core.ih = open[0].h()
        initialized = true
    }
    
    static func getSuccessors(t:Tile) -> [Tile] {
        var rv:[Tile] = [Tile]()
        
        let possibleCoords:[[Int]] = [[t.ix-1,t.iy+1],[t.ix,t.iy+1],[t.ix+1,t.iy+1],[t.ix-1,t.iy],[t.ix+1,t.iy],[t.ix-1,t.iy-1],[t.ix,t.iy-1],[t.ix+1,t.iy-1]]
        
        for possibleCoord in possibleCoords {
            if possibleCoord[0] >= 0 && possibleCoord[0] < Core.TILEWIDTH && possibleCoord[1] >= 0 && possibleCoord[1] < Core.TILEHEIGHT && Core.map.getTile(xpos: possibleCoord[0], ypos: possibleCoord[1]).getType() != Tile.TileType.obstacle {
                let s:Tile = Core.map.getTile(xpos: possibleCoord[0], ypos: possibleCoord[1])
                
                //var n:Tile = Tile(type: s.getType(), ix: s.ix, iy: s.iy)
                //n.parent = t
                rv.append(s)
            }
        }
        
        return rv
    }
    
    static func tcCompare(t:Tile, c:[Int]) -> Bool {
        return (t.ix == c[0] && t.iy == c[1])
    }
    
    static func ttCompare(t1:Tile, t2:Tile) -> Bool {
        return (t1.ix == t2.ix && t1.iy == t2.iy)
    }
    
    static func drawPath(t:Tile) -> Void {
        if t.parent?.ix ?? -1 != -1 {
            if Core.map.grid[t.ix][t.iy].getType() != Tile.TileType.point {
                Core.map.grid[t.ix][t.iy].setType(type: Tile.TileType.path)
            }
            drawPath(t:t.parent!)
        }
        else {
            // start point, recursive breakout condition
        }
    }
    
    static func nextStep() -> Bool {
        if !initialized {
            initSim()
        }
        
        if open.count == 0 {
            return false
        }
        
        var smallestF:Double = open[0].f()
        
        // for the graphics
        var largestF:Double = open[0].f()
        
        var smallestIndex = 0
        for index in 1..<open.count {
            if open[index].f() < smallestF {
                smallestF = open[index].f()
                smallestIndex = index
            }
            
            if open[index].f() > largestF {
                largestF = open[index].f()
            }
        }
        
        if smallestF != 0.0 {
            Core.smallestf = smallestF
        }
        
        Core.largestf = largestF
                
        let q = open.remove(at: smallestIndex)
        
        closed.append(q)
        if Core.map.grid[q.ix][q.iy].getType() != Tile.TileType.point {
            Core.map.grid[q.ix][q.iy].setType(type: Tile.TileType.closed)
        }
        
        if tcCompare(t: q, c: Core.terminus) {
            // end point
            drawPath(t: q)
            return false
        }
        
        let successors = getSuccessors(t: q)
        
        for successor in successors {
            var tentg:Double = -1.0
            
            if !((abs(q.ix - successor.ix) == 1) && (abs(q.iy - successor.iy) == 1)) {
                // not diagonal
                tentg = q.g() + 1
            } else {
                // is diagonal; need to use pythagorean theorem
                tentg = q.g() + sqrt(2.0)
            }
            
            if tentg < successor.g() {
                successor.parent = q
                successor.gval = tentg
                successor.fval = tentg + successor.h()
                
                if !closed.contains(successor) {
                    open.append(successor)
                                        
                    if Core.map.grid[successor.ix][successor.iy].getType() != Tile.TileType.point {
                        Core.map.grid[successor.ix][successor.iy].setType(type: Tile.TileType.open)
                    }
                }
            }
        }
      
        return true
    }
}
