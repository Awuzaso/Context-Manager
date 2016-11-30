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

class ViewController: NSViewController {
    
    @IBOutlet weak var statusLabel:NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    let sizeFormatter = NSByteCountFormatter()
    var directory:Directory?
    var directoryItems:[Metadata]?
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.stringValue = ""
        tableView.setDelegate(self) // Tells tableView that its data source will be the view controller and that
        // setDataSource(_:) will call its methods.
        tableView.setDataSource(self)
        
        tableView.target = self
        tableView.doubleAction = "tableViewDoubleClick:"
        /*
         
         This tells the table view that the view controller will become the target for its actions, and then it sets the method
         that will be called after a double click.
         
         */
        // 1
        /*let descriptorName = NSSortDescriptor(key: Directory.FileOrder.Name.rawValue, ascending: true)
         let descriptorDate = NSSortDescriptor(key: Directory.FileOrder.Date.rawValue, ascending: true)
         let descriptorSize = NSSortDescriptor(key: Directory.FileOrder.Size.rawValue, ascending: true)*/
        
        let descriptorName = NSSortDescriptor(key: "Name", ascending: true)
        let descriptorDate = NSSortDescriptor(key: "Date", ascending: true)
        let descriptorSize = NSSortDescriptor(key: "Size", ascending: true)
        
        // 2
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorName;
        tableView.tableColumns[1].sortDescriptorPrototype = descriptorDate;
        tableView.tableColumns[2].sortDescriptorPrototype = descriptorSize;
        /*
         
         What goes on:
         
         1) Creates a sort descriptor for every column, complete with a key, e.g., Name, Date, Size, that indicates
         the attribute by which the file list can be ordered.
         
         2) Adds the sort descriptors to each column by setting its sortDescriptorPrototype property.
         
         When the user clicks on any column header, teh tbale view will call the data source method
         tableView(_:sortDescriptorsDidChange:oldDescriptors:), at which point the app should sort the data based on the
         supplied descriptor.
         
         */
    }
    
    override var representedObject: AnyObject? {
        didSet {
            if let url = representedObject as? NSURL {
                print("Represented object: \(url)")
                directory = Directory(folderURL: url)
                reloadFileList()
            }
        }
    }
    /*
     
     Creates an instance of Directory pointing to the folder URL, and
     it calls the reloadFileList() method to referesh the table view data.
     
     */
    
    
    func reloadFileList() {
        directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
        tableView.reloadData()
    }
    /*
     $ - This helper method refreshes the file list.
     
     $ - First, it calls the directory method contentsOrderedBy(_:ascending) and returns a sorted array with the directory files.
     
     $ - Then it calls the tbale view method reloadData() to tell it to refresh.
     
     $ - Note that you only need to call this method when a new direcotry is selected.
     */
    
    func tableViewDoubleClick(sender: AnyObject) {
        
        // 1
        guard tableView.selectedRow >= 0 , let item = directoryItems?[tableView.selectedRow] else {
            return
        }
        
        if item.isFolder {
            // 2
            self.representedObject = item.url
        } else {
            // 3
            NSWorkspace.sharedWorkspace().openURL(item.url)
        }
    }
    /*
     
     Step-by-step:
     1) If the table view selection is empty, it does nothing and returns. Also note that a double-click on an empty area of
     the table view will result in an tablleView.selectedRow value equal to -1.
     
     2) If it's a folder, it sets the representedObject property to the item's URL. Then the table view refreshes to show
     the contents of that folder.
     
     3) If the item is a file, it opens it in the default application by calling the NSWorkspace method openURL()
     
     */
}

extension ViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return directoryItems?.count ?? 0
    }
    
    
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        // 1
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        if let order = Directory.FileOrder(rawValue: sortDescriptor.key! ) {
            // 2
            sortOrder = order
            sortAscending = sortDescriptor.ascending
            reloadFileList()
        }
    }
    /*
     
     The code does the following:
     
     1) Retrieves the first sort descriptor that corresponds to the column header clicked by the user.
     
     2) Assigns the sortOrder and sortAscending properties of the view controller, and then calls reloadFileList().
     
     2.1) You set it up earlier to get a sorted array of files and tells the table view to relaod the data.
     
     */
}

extension ViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image:NSImage?
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1
        guard let item = directoryItems?[row] else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            image = item.icon
            text = item.name
            cellIdentifier = "NameCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.date.description
            cellIdentifier = "DateCellID"
        } else if tableColumn == tableView.tableColumns[2] {
            text = item.isFolder ? "--" : sizeFormatter.stringFromByteCount(item.size)
            cellIdentifier = "SizeCellID"
        }
        
        // 3
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        return nil
    }
}

