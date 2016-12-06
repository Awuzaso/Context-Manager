//
//  previewManager.swift
//  ContextManager_HCC
//
//  Created by ContextManager on 12/5/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class previewManager
{
    func getCurrentPreviewFiles() -> String{
        var collectedPreviews = " "
        let previewCollectingScript = "set r to \"\"\n" +
            "tell application \"System Events\"\n" +
            "repeat with theProcess in (every process)\n" +
            "if background only of theProcess is false then\n" +
            "if name of theProcess is \"Preview\" then\n" +
            "tell process \"Preview\"\n" +
            "repeat with x from 1 to (count windows)\n" +
            "set documentPath to value of attribute \"AXDocument\" of window x\n" +
            "set r to r & documentPath & \"$\"\n" +
            "log documentPath\n" +
            "end repeat\n" +
            "end tell\n" +
            "end if\n" +
            "end if\n" +
            "end repeat\n" +
            "end tell\n" +
        "return r"
        var error: NSDictionary?
        let previewScriptObject = NSAppleScript(source: previewCollectingScript)
        if let output: NSAppleEventDescriptor = previewScriptObject?.executeAndReturnError(&error)
        {
            collectedPreviews = output.stringValue!
            print("Targets:\(collectedPreviews)")
        }
        else if (error != nil)
        {
            print("error: \(error)")
        }
        
        print("DesktopWindowManager : Got all current open windows.")
        
        return collectedPreviews
    }
    
    func openAllPreviews(collectedPreview:String)
    {
        let separatedPreviews = collectedPreview.characters.split{$0 == "$"}.map(String.init)
        for i in separatedPreviews
        {
            if let url = NSURL(string: i) where NSWorkspace.sharedWorkspace().openURL(url) //NSWorkspace.shared().open(url)
                
            {
                
                print("Previews successfully opened.")
                
            }
                
            else
                
            {
                
                print("Previews not opened.")
                
            }

        }

        
    }
}
