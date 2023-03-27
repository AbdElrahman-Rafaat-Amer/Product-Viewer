//
//  ProductViewModel.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation
import CoreData

class ProductViewModel : RequestDelegate {
    
    private let repository = ProductRepository()
    private var viewDelegate : RequestDelegate!
    
    func getProducts(delegate: RequestDelegate){
        self.viewDelegate = delegate
        viewDelegate.updateState(with: .loading)
        repository.getProducts(delegate: self)
    }
    
    func updateState(with state: ViewState) {
        switch state {
        case .error(let errorMessage):
            viewDelegate.updateState(with: .error(errorMessage))
            
        case .success(let data):
            let sortedProducts = sortProductsAlpahbaticlly(data : data)
            viewDelegate.updateState(with: .success(sortedProducts))
            
        default :
            print("Unkown State")
        }
    }
    
    private func sortProductsAlpahbaticlly(data : [Product]) -> [Product]{
        let sortedProducts = data.sorted {
            $0.name.lowercased() <  $1.name.lowercased()
        }
        return sortedProducts
    }
}
