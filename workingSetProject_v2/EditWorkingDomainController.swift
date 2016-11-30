//
//  EditWorkingDomainController.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/23/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class EditWorkingDomainController: NSViewController {

    let launchWindowTable = tableViewManager()
    
    /*Variables for Sorting Table View*/
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true
    var directory:Directory?
    var directoryItems:[Metadata]?
    
    /*Variables*/
    var nameOfCard: String! //Selected WS
    var cardsAssociated = [NSManagedObject]() //Stores the associated cards of a given working domain.
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var textLabel: NSTextField!
    @IBOutlet weak var addCurrentCardButton: NSButton!
    @IBOutlet weak var removePrevCardButton: NSButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        singleton.canOpenAssocWindow = false
        
        init_cardAssociatedList()
        
        tableView!.setDelegate(self)
        tableView!.setDataSource(self)
        tableView!.target = self
        tableView.doubleAction = "tableViewDoubleClick:"
        textLabel.stringValue = singleton.openedWD
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableAssociateButton", name: "enableAssoc", object: nil)
        
        
        
        if( singleton.canAssociateVar == false ){
            addCurrentCardButton.enabled = false
            //removePrevCardButton.enabled = false
        }
 
    }
    
    func enableAssociateButton(){
        addCurrentCardButton.enabled = true
    }
    
    func reloadFileList() {
        //directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)   // Calls sorting function. Returns sorted array
        cardsAssociated.removeAll()
        init_cardAssociatedList()
        tableView!.reloadData()
        
        
        print( "Data was reloaded." )
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
                reloadFileList()
        }
    }

   
    
    @IBAction func onEnterCardName(sender: NSTextField) {
        
        
        
        let selectedRowNumber = tableView.selectedRow
        
        
        
        if selectedRowNumber != -1 {  //-1 is returned when no row is selected in the TableView
            //items[selectedRowNumber] = sender.stringValue  //items is the data source, which is an array of Strings to be displayed in the TableView
            //print("The value is now: \(items[selectedRowNumber])")
            
            //let editCardOwner = cardsAssociated[selectedRowNumber].valueForKey("cardOwner") as! String
            
            let idCardName = cardsAssociated[selectedRowNumber].valueForKey("rfidValue") as! String
            
            
            singleton.coreDataObject.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "cardName", idName: idCardName, editName: sender.stringValue)
            
            print( singleton.coreDataObject.getEntityObject("Card", idKey: "rfidValue", idName: idCardName) )
            
            //print("Name of card owner was changed to \(sender.stringValue)")
            
            //tableView.reloadData()
        }
        
        
    }
 
    
    
    @IBAction func onEnterCardOwner(sender: NSTextField) {
        
        let selectedRowNumber = tableView.selectedRow
        
        
        
        if selectedRowNumber != -1 {  //-1 is returned when no row is selected in the TableView
            //items[selectedRowNumber] = sender.stringValue  //items is the data source, which is an array of Strings to be displayed in the TableView
            //print("The value is now: \(items[selectedRowNumber])")
            
            //let editCardOwner = cardsAssociated[selectedRowNumber].valueForKey("cardOwner") as! String
            
            let idCardOwner = cardsAssociated[selectedRowNumber].valueForKey("rfidValue") as! String
            
            
            singleton.coreDataObject.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "cardOwner", idName: idCardOwner, editName: sender.stringValue)
            
            print( singleton.coreDataObject.getEntityObject("Card", idKey: "rfidValue", idName: idCardOwner) )
            
            print("Name of card owner was changed to \(sender.stringValue)")
            
            //tableView.reloadData()
        }

    }
    
    
    @IBAction func onEnterSaveName(sender: NSTextField) {
        print("Saving...")
        let valueToSend = textLabel.stringValue
        singleton.openedWD = valueToSend
        NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)

        
    }
    
        
    
    
    
    
    @IBAction func addCurrentCard_Button(sender: AnyObject) {
        
        let openedWD = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD)
        
        let cards = openedWD.mutableSetValueForKey("associatedCards")
        cards.addObject(singleton.readCard)
        singleton.coreDataObject.saveManagedContext()
        print("$$$$$$$$")
        print(cards)
         print("$$$$$$$$")
        //tableView.reloadData()
        reloadFileList()
    }
    
    
    @IBAction func removePrevCard_Button(sender: AnyObject) {
        print( "Removed card." )
        
        let selectedRowNumber = tableView.selectedRow
        
        if selectedRowNumber != -1 {
            
            let rfidValue = cardsAssociated[selectedRowNumber].valueForKey("rfidValue") as! String
            
            singleton.coreDataObject.deleteEntityObject("Card", nameOfKey: "rfidValue", nameOfObject: rfidValue)
            
            
            
            reloadFileList()
        }
        
  
        
    }
    
    
    @IBAction func save_Button(sender: AnyObject) {
        print("Saving...")
        let valueToSend = textLabel.stringValue
        singleton.openedWD = valueToSend
        NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
    }
    
    
    @IBAction func cancel_Button(sender: AnyObject) {
        singleton.canOpenAssocWindow = true
        singleton.openWindowObject.stopEvents()
    }
    
    
    
}
