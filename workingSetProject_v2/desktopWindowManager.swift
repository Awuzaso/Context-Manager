//
//  desktopWindowManager.swift
//  ContextManager_HCC
//
//  Created by ContextManager on 12/5/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class desktopWindowManger {
    
    func getCurrentWindows() -> String
    {
        
        var collectedWindows = " "
        
        let windowCollectingScript = "set r to \"\"\n" +
            "tell application \"System Events\"\n" +
            "repeat with theProcess in (every process)\n" +
            "if background only of theProcess is false then\n" +
            "if name of theProcess is \"Finder\" then\n" +
            "activate\n" +
            "tell application \"Finder\"\n" +
            "repeat with x from 1 to (count windows)\n" +
            "set targetInfo to target of window x\n" +
            "set r to r & targetInfo & \"$\"\n" +
            "log targetInfo\n" +
            "end repeat\n" +
            "end tell\n" +
            "end if\n" +
            "end if\n" +
            "end repeat\n" +
            "end tell\n" +
        "return r"
        
        var error: NSDictionary?
        let windowScriptObject = NSAppleScript(source: windowCollectingScript)
        if let output: NSAppleEventDescriptor = windowScriptObject?.executeAndReturnError(&error)
        {
            collectedWindows = output.stringValue!
            print("Targets:\(collectedWindows)")
        }
        else if (error != nil)
        {
            print("error: \(error)")
        }
        
        print("DesktopWindowManager : Got all current open windows.")
        
        return collectedWindows
    }
    
    func closeAllWindows()
    {
        print("DesktopWindowManager : Closed all open windows.")
    }
    
    func openAllWindows(collectedWindow:String)
    {
        
        let separatedWindows = collectedWindow.characters.split{$0 == "$"}.map(String.init)
        for i in separatedWindows
            {
                var finderURL = NSString(string: i)
                finderURL = finderURL.stringByReplacingOccurrencesOfString(":", withString: "/")
                finderURL = finderURL.stringByReplacingOccurrencesOfString("Macintosh HD", withString: "")
                if (NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: finderURL as String))
                {
                    print("Window opened successfully.")
                }
                else
                {
                    print("Window was not opened.")
                }


            }
        
        print("DesktopWindowManager : Openned all windows.")
    }
    
}
