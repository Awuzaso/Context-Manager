//
//  AppDelegate_Ext.swift
//  workingSetProject_v2
//
//  Created by Osa on 8/2/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

extension AppDelegate{
    

    func initializeApp(){
        
        /*Get the path name of the serial port.*/
        let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
        let serPort = serialPortManager.availablePorts
        let selectedPort = serPort[0]
        let pthNm = "/dev/cu.\(selectedPort)"
        print( pthNm )
        
        
        /*Setting the serial port object for the singleton.*/

        singleton.serialPortObject = SerialPortManager(pathName: pthNm ,in_nameOfStoryBoard: "Main" ,in_nameOfWinUnAssoc:"UAWindow",  in_nameOfWinAssoc: "AWindow")
        
        singleton.serialPath = pthNm
        
    }
 
    
    
}
