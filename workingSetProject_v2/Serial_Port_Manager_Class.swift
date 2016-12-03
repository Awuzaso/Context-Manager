//
//  Serial_Port_Manager_Class.swift
//  test
//
//  Created by Osa on 6/24/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa


var stringVar:String!

class SerialPortManager:NSObject,ORSSerialPortDelegate{
    
    var oldStringVal: NSString = "OldValue"
    
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    
    
    var serialPort: ORSSerialPort!
   
    // MARK: - Modal Window Variables
    
    var nameOfStoryboard: String!
    
    var nameOfWindowIfUnassociated: String!
    
    var nameOfWindowIfAssociated: String!
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    init(pathName:String,in_nameOfStoryBoard: String, in_nameOfWinUnAssoc:String, in_nameOfWinAssoc:String){
        super.init()
        
        nameOfStoryboard = in_nameOfStoryBoard
        nameOfWindowIfAssociated = in_nameOfWinAssoc
        nameOfWindowIfUnassociated = in_nameOfWinUnAssoc
       let tpathName = "/dev/cu.Bluetooth-Incoming-Port"
        
        
        
        //serialPort = ORSSerialPort(path: "/dev/cu.\(setPath)")  //Essentially i'm ignoring pathName.
        serialPort = ORSSerialPort(path: "\(pathName)")
        
        let descriptor = ORSSerialPacketDescriptor(prefixString: "_", suffixString: "\n" , maximumPacketLength: 34, userInfo: nil)
        //let descriptor = ORSSerialPacketDescriptor.init
        serialPort.startListeningForPacketsMatchingDescriptor(descriptor)
  
        
        if( serialPort == nil ){
            print( "Not ready.")
            serialPort = ORSSerialPort(path: "\(tpathName)")
        }
        else{
            print("Serial Port is Ready.")
        }
        
        serialPort?.delegate = self
        serialPort!.baudRate = 115200
        serialPort!.numberOfStopBits = 1
        
        serialPort!.open()
       
    }
    
    func openSerialPort(){
        serialPort.open()
    }
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func get_SerialPorts()->Array<String>{
        var arrayOfPorts_string:[String]!
        var arrayOfPorts = serialPortManager.availablePorts
        
        for(var i = 0; i < arrayOfPorts.count; i += 1){
            print(arrayOfPorts[i])
            let value = "\(arrayOfPorts[i])"
            
            arrayOfPorts_string[i] = value
        }
        
        return arrayOfPorts_string
    }
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func launchWindow(nameOfWindow:String){
        
        // 1
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let openWindowController = storyboard.instantiateControllerWithIdentifier(nameOfWindow) as! NSWindowController
        
        // 2
        if let openModalWindow = openWindowController.window{
            
            // 3
            let application = NSApplication.sharedApplication()
            application.runModalForWindow(openModalWindow)
            
        }
        
    }
    
    // MARK: - ORSSerialPortDelegate
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Open!")
        let arrayObject : [AnyObject] = [true]
        NSNotificationCenter.defaultCenter().postNotificationName("scanSet", object: arrayObject)

        
    }
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func serialPortWasClosed(serialPort: ORSSerialPort) {
        print("Closed!")
        let value = false

        let arrayObject : [AnyObject] = [false]
        NSNotificationCenter.defaultCenter().postNotificationName("scanSet", object: arrayObject)

    }
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func serialPort(serialPort: ORSSerialPort, didReceivePacket packetData: NSData, matchingDescriptor descriptor: ORSSerialPacketDescriptor) {
        print("reading...")
        let arrayObject : [AnyObject] = [true]
        NSNotificationCenter.defaultCenter().postNotificationName("scanSet", object: arrayObject)
        
        if let string = NSString(data: packetData, encoding: NSUTF8StringEncoding) {
            
     
            print( string )
            
            
            
            let sendVal = (string as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            
            // - Bool value to evaluate if card is already in database of not.
            let cardIsInDB = singleton.coreDataObject.evaluateIfCardIsInDB("Card", nameOfKey: "rfidValue", nameOfObject: sendVal)
            
            // - Case if card is in data base.
                if(cardIsInDB == false){
                    print("Card is not in the database.")
                    // - Brings up a modal window to tell user that the card is a new to the database.
//                    if(singleton.canOpenAssocWindow == true){
//                        singleton.openWindowObject.setWindow("Main", nameOfWindowController: "UAWindow")
//                        singleton.openWindowObject.runModalWindow()
//                    }
                    
                    
                    
                    
                    singleton.readCard = singleton.coreDataObject.getEntityObject("Card", idKey: "rfidValue", idName: sendVal)
                    NSNotificationCenter.defaultCenter().postNotificationName("enableAssoc", object: nil)
                }
            // - Case if card read is in the data base.
                else{
                    print("Card is in the database.")
                    // - Assigns the value of the currently read card.
                        singleton.readCard = singleton.coreDataObject.getEntityObject("Card", idKey: "rfidValue", idName: sendVal)
                        //NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
                    // - Enables the option to associate card.
                        singleton.canAssociateVar = true
                    
                    
                    // - Retrieves the WD associated with the card and assigns it to a constant to be retrieve from fault.
                        let associatedWD = singleton.readCard.valueForKey("associatedWD")
                    
                    // - Assigns the name of the associated WD.
                        let nameOfAssociatedWD = associatedWD?.valueForKey("nameOfWD")
                    
                    // - Opens WD window associated with card.
                        if(nameOfAssociatedWD != nil){
                            // - 1 - Sets the value of the currently opened WD to the name value associated with the card.
                            singleton.openedWD = associatedWD?.valueForKey("nameOfWD") as! String
                            //NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
                            NSNotificationCenter.defaultCenter().postNotificationName("associateWindow", object: nil)
                        }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("enableAssoc", object: nil)
                }
            
        }
    }
    
    
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        print("Serial port, \(serialPort) was removed from the system.")
        let arrayObject : [AnyObject] = [false]
        NSNotificationCenter.defaultCenter().postNotificationName("scanSet", object: arrayObject)
    }
    
    

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port, \(error) was removed from the system.")
        let arrayObject : [AnyObject] = [false]
        NSNotificationCenter.defaultCenter().postNotificationName("scanSet", object: arrayObject)
        
    }
    
    
/*END OF CLASS*/

}
