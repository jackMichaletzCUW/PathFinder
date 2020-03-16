//
//  SimView.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/14/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa
import CoreGraphics

class SimView: NSView {
    
    
    let openColor = CGColor(red: CGFloat(0xAC as Float / 0xFF), green: CGFloat(0xB3 as Float / 0xFF), blue: CGFloat(0x69 as Float / 0xFF), alpha: 1.0)
    let closedColor = CGColor(red: CGFloat(0x8C as Float / 0xFF), green: CGFloat(0x93 as Float / 0xFF), blue: CGFloat(0x49 as Float / 0xFF), alpha: 1.0)
    let unvisitedColor = CGColor(red: CGFloat(0xF7 as Float / 0xFF), green: CGFloat(0xFE as Float / 0xFF), blue: CGFloat(0xAE as Float / 0xFF), alpha: 1.0)
    let obstacleColor = CGColor(red: CGFloat(0xB3 as Float / 0xFF), green: CGFloat(0x76 as Float / 0xFF), blue: CGFloat(0x72 as Float / 0xFF), alpha: 1.0)
    let pointColor = CGColor(red: 0.0, green:0.0, blue: 0.0, alpha: 1.0)
    let pathColor = CGColor(red: 0.3, green:0.3, blue: 0.3, alpha: 1.0)
    
    public func repaint() -> Void {
        setNeedsDisplay(NSRect(x: 0,y: 0,width: 600,height: 600))
    }
    
    override func mouseDown(with event: NSEvent) {
        if Core.stage == 1 {
            // get mouse coordinates and map them to a tile
            let mox = Int(event.locationInWindow.x)
            let moy = Int(event.locationInWindow.y)
            
            let tix:Int = mox / 10
            let tiy:Int = moy / 10
            
            if Core.origin[0] == -1 && Core.origin[1] == -1 {
                Core.map.grid[tix][tiy].setType(type: Tile.TileType.point)
                Core.origin[0] = tix
                Core.origin[1] = tiy
            }
            else if Core.terminus[0] == -1 && Core.terminus[1] == -1 {
                Core.map.grid[tix][tiy].setType(type: Tile.TileType.point)
                Core.terminus[0] = tix
                Core.terminus[1] = tiy
            }
            else {
                //Core.cycleStage()
            }
            
            self.repaint()
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        // only allow drawing obstacles in first stage
        if Core.stage == 0 {
            // get mouse coordinates and map them to a tile
            let mox = Int(event.locationInWindow.x)
            let moy = Int(event.locationInWindow.y)
            
            let tix:Int = mox / 10
            let tiy:Int = moy / 10
            
            // generate a rectangle for obstacle paintbrush
            let minx:Int = (tix - 2 > 0 ? (tix - 2 < 59 ? tix - 2 : 59) : 0)
            let maxx:Int = (tix + 2 < 59 ? (tix + 2 > 0 ? tix + 2 : 0) : 59)
            
            let miny:Int = (tiy - 2 > 0 ? (tiy - 2 < 59 ? tiy - 2 : 59) : 0)
            let maxy:Int = (tiy + 2 < 59 ? (tiy + 2 > 0 ? tiy + 2 : 0) : 59)
            
            // mark as obstacles
            for ix in minx...maxx {
                for iy in miny...maxy {
                    Core.map.grid[ix][iy].setType(type: Tile.TileType.obstacle)
                }
            }
            
            self.repaint()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let context = NSGraphicsContext.current?.cgContext
        
        for x in 0...59 {
            for y in 0...59 {
                switch Core.map.grid[x][y].getType() {
                    case Tile.TileType.obstacle:
                        context?.setFillColor(obstacleColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                    case Tile.TileType.open:
                        context?.setFillColor(openColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                    case Tile.TileType.closed:
                        context?.setFillColor(closedColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                    case Tile.TileType.unvisited:
                        context?.setFillColor(unvisitedColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                    case Tile.TileType.point:
                        context?.setFillColor(pointColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                    case Tile.TileType.path:
                        context?.setFillColor(pathColor)
                        context?.fill(CGRect(x: x * 10, y: y * 10, width: 10, height: 10))
                        break
                }
            }
        }
    }
    
}
