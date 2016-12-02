//
//  contextManagerWindowController.swift
//  workingSetProject_v2
//
//  Created by Awuzaso on 12/2/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class contextManagerWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        
        
        
        window?.backgroundColor = NSColor.yellowColor()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    
    override init(window: NSWindow!)
    {
        super.init(window: window)
        print(__FILE__, __FUNCTION__)
    }
    
    required init?(coder: (NSCoder!))
    {
        super.init(coder: coder)
        print(__FILE__, __FUNCTION__)
    }
    
    
    
}
