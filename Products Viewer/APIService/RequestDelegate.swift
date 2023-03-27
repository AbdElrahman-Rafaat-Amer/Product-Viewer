//
//  RequestDelegate.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation

protocol RequestDelegate: AnyObject {
    func updateState(with state: ViewState)
}
