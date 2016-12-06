//
//  removeWindow.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/18/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class removeWindow: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    
    @IBAction func OK_Button(sender: AnyObject) {
        
        // NOTIFICATION GOES HERE
        //notify()
        NSNotificationCenter.defaultCenter().postNotificationName("remove", object: nil)
        singleton.openWindowObject.stopEvents()
    
        
    }
    
    
    
    @IBAction func Cancel_Button(sender: AnyObject) {
        
        
        singleton.openWindowObject.stopEvents()
        
        
        
        
    }
    
    
    
}
