//
//  contextManagerWindow.swift
//  workingSetProject_v2
//
//  Created by Awuzaso on 12/2/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class contextManagerWindow: NSWindowController {

    override init()
    {
        super.init()
        println(__FILE__, __FUNCTION__)
    }
    
    override init(window: NSWindow!)
    {
        super.init(window: window)
        println(__FILE__, __FUNCTION__)
    }
    
    required init?(coder: (NSCoder!))
    {
        super.init(coder: coder)
        println(__FILE__, __FUNCTION__)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        println(__FILE__, __FUNCTION__)
    }
    
    
    
}
