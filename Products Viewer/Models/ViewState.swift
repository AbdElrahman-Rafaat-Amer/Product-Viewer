//
//  ViewState.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation

enum ViewState {
    case loading
    case success([Product])
    case error(Error)
}
