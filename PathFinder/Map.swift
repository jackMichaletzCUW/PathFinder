//
//  Map.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/14/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa

class Map: NSObject {
    
    public var grid:[[Tile]] = Array(repeating: Array(repeating: Tile(type: Tile.TileType.unvisited, ix:-1, iy:-1), count: 60), count: 60)
    
    public func getTile(xpos:Int, ypos:Int) -> Tile {
        return self.grid[xpos][ypos]
    }
    
    override init() {
        for x in 0...59 {
            for y in 0...59 {
                grid[x][y] = Tile(type: Tile.TileType.unvisited, ix:x, iy:y)
            }
        }
    }
}
