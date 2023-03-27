//
//  UINavigationController.swift
//  Products Viewer
//
//  Created by Abdelrahman on 07/03/2023.
//

import Foundation
import ENSwiftSideMenu

class SideNavigationController : ENSideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a table view controller
        let tableViewController = MyMenuTableViewController()
        
        // Create side menu
        sideMenu = ENSideMenu(sourceView: view, menuViewController: tableViewController, menuPosition:.left)
        
        // Set a delegate
        sideMenu?.delegate = self
        
        // Configure side menu
        sideMenu?.menuWidth = 180.0
        
        // Show navigation bar above side menu
        view.bringSubviewToFront(navigationBar)
        
    }
}

extension SideNavigationController: ENSideMenuDelegate {
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("SideNavigationController---------->sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuWillOpen() {
        print("SideNavigationController---------->sideMenuWillOpen")
    }
    
    func sideMenuDidOpen() {
        print("SideNavigationController---------->sideMenuDidOpen")
    }
    
    func sideMenuWillClose() {
        print("SideNavigationController---------->sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("SideNavigationController---------->sideMenuDidClose")
    }
    
}
