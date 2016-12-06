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
        
        
        
        //OpenURL()
        //CheckChromeTabs()
        
    }

    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    // INTERFACE FUNCTIONS
    @IBAction func launchWSDM_Window(sender: AnyObject){
        // - 1 Launches preivously set up WSDM window.
            windowController.showWindow(sender)
    }

    
    func CheckChromeTabs()
        
    {
        /*From Shyam*/
        let myAppleScript = "set r to \"\"\n" +
            
            "tell application \"Google Chrome\"\n" +
            
            "repeat with w in windows\n" +
            
            "repeat with t in tabs of w\n" +
            
            "tell t to set r to r & \"Title : \" & title & \", URL : \" & URL & linefeed\n" +
            
            "end repeat\n" +
            
            "end repeat\n" +
            
            "end tell\n" +
            
        "return r"
        
        var error: NSDictionary?
        
        let scriptObject = NSAppleScript(source: myAppleScript)
        
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error)
            
        {
            
            let titlesAndURLs = output.stringValue!
            
            print(titlesAndURLs)
            
        }
            
        else if (error != nil)
            
        {
            
            print("error: \(error)")
            
        }
        
    }
    
    
    
    func OpenURL()
        
    {
        /*From Shyam*/
        //var url: NSURL!
        
        
        
        print("OpenURL")
        
        
        
        if let url = NSURL(string: "https://www.google.com") where NSWorkspace.sharedWorkspace().openURL(url) //NSWorkspace.shared().open(url)
            
        {
            
            print("default browser was successfully opened")
            
        }
            
        else
            
        {
            
            print("browser was not opened successfully")
            
        }
        
    }
    
    
}

