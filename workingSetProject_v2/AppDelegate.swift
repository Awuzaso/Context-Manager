//
//  AppDelegate.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/3/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   
            var secondsPassed = 0.0
        /*Sets up constants.*/
            let openWindowObject = windowManager()
            let openWindowObject2 = windowManager()
        /*Sets up varuables.*/
            var windowController = NSWindowController()
            var unassocCardWinController = NSWindowController()
            var serialPortObject: SerialPortManager!
  
    func event(){
        print("Timer is going for \(secondsPassed)")
        secondsPassed = secondsPassed + 10
    }
    
    
    // PRIMARY FUNCTIONS
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // - 1 Calls function to initialize values for app.
            print("Initializing App")
        
            initializeApp()
        
        // - 2 - Initialize WSDM window
            //init_WSDM_Window()
        
        // - 3 - Launch WSDM window.
            //launchWSDM_Window(self)
        
    }

    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    // INTERFACE FUNCTIONS
    @IBAction func launchWSDM_Window(sender: AnyObject){
        // - 1 Launches preivously set up WSDM window.
            windowController.showWindow(sender)
    }

    
}

