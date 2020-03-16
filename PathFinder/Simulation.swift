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
        initialized = true
    }
    
    static func getSuccessors(t:Tile) -> [Tile] {
        var rv:[Tile] = [Tile]()
        
        let possibleCoords:[[Int]] = [[t.ix-1,t.iy+1],[t.ix,t.iy+1],[t.ix+1,t.iy+1],[t.ix-1,t.iy],[t.ix+1,t.iy],[t.ix-1,t.iy-1],[t.ix,t.iy-1],[t.ix+1,t.iy-1]]
        
        for possibleCoord in possibleCoords {
            if possibleCoord[0] >= 0 && possibleCoord[0] < Core.TILEWIDTH && possibleCoord[1] >= 0 && possibleCoord[1] < Core.TILEHEIGHT && Core.map.getTile(xpos: possibleCoord[0], ypos: possibleCoord[1]).getType() != Tile.TileType.obstacle {
                let s:Tile = Core.map.getTile(xpos: possibleCoord[0], ypos: possibleCoord[1])
                
                var n:Tile = Tile(type: s.getType(), ix: s.ix, iy: s.iy)
                n.parent = t
                rv.append(n)
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
    
    static func tileInOpenList(t:Tile) -> Bool {
        for tile in open {
            if ttCompare(t1: t, t2: tile) {
                return true
            }
        }
        
        return false
    }
    
    static func tileInClosedList(t:Tile) -> Bool {
        for tile in closed {
            if ttCompare(t1: t, t2: tile) {
                return true
            }
        }
        
        return false
    }
    
    static func nextStep() -> Bool {
        if !initialized {
            initSim()
        }
        
        if open.count == 0 {
            return false
        }
        
        var smallF:Int = open[0].f()
        var sfidx = 0
        for idx in 1..<open.count {
            if open[idx].f() < smallF {
                smallF = open[idx].f()
                sfidx = idx
            }
        }
        
        let q = open.remove(at: sfidx)
        
        if tcCompare(t: q, c: Core.terminus) {
            // end point
            drawPath(t: q)
            return false
        }
        
        let successors = getSuccessors(t: q)
        
        for successor in successors {
            //print("ix: " + String(successor.ix) + ", iy: " + String(successor.iy))
            
            if tileInClosedList(t: successor) {
                continue
            }
            
            let tentg = q.g() + 1
        
            if tentg < successor.g() || !tileInOpenList(t: successor) {
                successor.gval = tentg
                successor.fval = tentg + successor.h()
                
                if !tileInOpenList(t: successor) {
                    open.append(successor)
                    if Core.map.grid[successor.ix][successor.iy].getType() != Tile.TileType.point {
                        Core.map.grid[successor.ix][successor.iy].setType(type: Tile.TileType.open)
                    }
                }
            }
            /*else if tileInOpenList(t: successor) || tileInClosedList(t: successor) {
                continue
            }
            else {
                Core.map.grid[successor.ix][successor.iy].setType(type: Tile.TileType.open)
                open.append(successor)
            }*/
        }
        
        closed.append(q)
        if Core.map.grid[q.ix][q.iy].getType() != Tile.TileType.point {
            Core.map.grid[q.ix][q.iy].setType(type: Tile.TileType.closed)
        }
        
        return true
    }
}
