//
//  chromeManager.swift
//  ContextManager_HCC
//
//  Created by Awuzaso on 12/4/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class chromeManager{
    
    func CheckChromeTabs()
        
    {
        /*From Shyam*/
//        let myAppleScript = "set r to \"\"\n" +
//            
//            "tell application \"Google Chrome\"\n" +
//            
//            "repeat with w in windows\n" +
//            
//            "repeat with t in tabs of w\n" +
//            
//            "tell t to set r to r & \"Title : \" & title & \", URL : \" & URL & linefeed\n" +
//            
//            "end repeat\n" +
//            
//            "end repeat\n" +
//            
//            "end tell\n" +
//            
//        "return r"
        
        let myAppleScript = "set r to \"\"\n" +
            
            "tell application \"Google Chrome\"\n" +
            
            "repeat with w in windows\n" +
            
            "repeat with t in tabs of w\n" +
            
            "tell t to set r to r & URL & \"$\"\n" +
            
            "end repeat\n" +
            
            "end repeat\n" +
            
            "end tell\n" +
            
        "return r"

        
        var error: NSDictionary?
        
        let scriptObject = NSAppleScript(source: myAppleScript)
        
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error)
            
        {
            
            let inVal = output.stringValue
            
            let outVal = inVal!.characters.split{$0 == "$"}.map(String.init)
            
            print(outVal)
            
            //let titlesAndURLs = output.stringValue!
            
            //print(titlesAndURLs)
            
        }
            
        else if (error != nil)
            
        {
            
            print("error: \(error)")
            
        }
        
    }
    
    
    
    func getURLFromBrowser() -> String{
        
        var collectedURLS = " "
        
        let myAppleScript = "set r to \"\"\n" +
            
            "tell application \"Google Chrome\"\n" +
            
            "repeat with w in windows\n" +
            
            "repeat with t in tabs of w\n" +
            
            "tell t to set r to r & URL & \"$\"\n" +
            
            "end repeat\n" +
            
            "end repeat\n" +
            
            "end tell\n" +
            
        "return r"
        
        
        var error: NSDictionary?
        
        let scriptObject = NSAppleScript(source: myAppleScript)
        
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error)
            
        {
            
            collectedURLS = output.stringValue!
            
            //let outVal = inVal!.characters.split{$0 == "$"}.map(String.init)
            
            //print(outVal)
            
            let titlesAndURLs = output.stringValue!
            
            //print(titlesAndURLs)
            
        }
            
        else if (error != nil)
            
        {
            
            print("error: \(error)")
            
        }
        
        
        return collectedURLS
        
    }
    
    
    
    func closeWindows(){
        
        
        /*From Shyam*/
        let myAppleScript = "tell application \"System Events\" to set quitapps to name of every application process whose visible is true and name is not \"ContextManager_HCC\" and name is not \"Finder\"\n" +
            
            "repeat with closeall in quitapps\n" +
            
            "quit application closeall\n" +
            
            "end repeat\n"
        
        
        var error: NSDictionary?
        
        let scriptObject = NSAppleScript(source: myAppleScript)
        
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&error)
            
        {
            
            //let titlesAndURLs = output.stringValue!
            
            //print(titlesAndURLs)
            
        }
            
        else if (error != nil)
            
        {
            
            print("error: \(error)")
            
        }

    }
    
    
    func OpenCollectedURLS(collectedURL:String){
        
        
        let separatedURLS = collectedURL.characters.split{$0 == "$"}.map(String.init)
        
        for i in separatedURLS{
        
        
            if let url = NSURL(string: i) where NSWorkspace.sharedWorkspace().openURL(url) //NSWorkspace.shared().open(url)
                
            {
                
                print("default browser was successfully opened")
                
            }
                
            else
                
            {
                
                print("browser was not opened successfully")
                
            }
            
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
        if let url = NSURL(string: "https://www.kotaku.com") where NSWorkspace.sharedWorkspace().openURL(url) //NSWorkspace.shared().open(url)
            
        {
            
            print("default browser was successfully opened")
            
        }
            
        else
            
        {
            
            print("browser was not opened successfully")
            
        }
        if let url = NSURL(string: "https://www.reddit.com") where NSWorkspace.sharedWorkspace().openURL(url) //NSWorkspace.shared().open(url)
            
        {
            
            print("default browser was successfully opened")
            
        }
            
        else
            
        {
            
            print("browser was not opened successfully")
            
        }

        
    }

    
    
    
    
    
    
    
    
    
    
}
