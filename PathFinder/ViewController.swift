//
//  ViewController.swift
//  PathFinder
//
//  Created by Jack Michaletz on 3/14/20.
//  Copyright © 2020 Jack Michaletz. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var simulation: SimView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Core.simulation = self.simulation!
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func nextStepClicked(_ sender: NSButton) {
        Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true, block: { timer in
            if Simulation.nextStep() {
                self.simulation.repaint()
            }
            else {
                self.simulation.repaint()
                timer.invalidate()
            }
        })
    }
    
    
    @IBAction func refreshClicked(_ sender: NSButton) {
        if Core.cycleStage() == 0 {
            Core.map = Map()
        }
        
        simulation.repaint()
    }
    
}

