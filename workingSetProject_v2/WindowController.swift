/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/


import Cocoa

func sendValue(urlVal:NSURL){
    // 1
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let openWindowController = storyboard.instantiateControllerWithIdentifier("Edit User Settings Window") as! NSWindowController
    
    // 2
    if let openWS_Window = openWindowController.window{
        
        /*
        let  open_WS_WindowController = openWS_Window.contentViewController as! Edit_User_Settings_Window
        print(open_WS_WindowController.File_Directory_Label.stringValue )
        open_WS_WindowController.File_Directory_Label.stringValue = urlVal.absoluteString
        */
    }
}

class WindowController: NSWindowController {
    var value = "Label"
    @IBAction func openDocument(sender: AnyObject?) {
        
        let openPanel = NSOpenPanel()
        openPanel.showsHiddenFiles      = false
        openPanel.canChooseFiles        = false
        openPanel.canChooseDirectories  = true
        
        openPanel.beginSheetModalForWindow(self.window!) {
            (response) -> Void in
            guard response == NSFileHandlingPanelOKButton else {
                return;
            }
            self.value = (openPanel.URL?.absoluteString)!
            //sendValue(openPanel.URL!)
        }
    }

  
}
