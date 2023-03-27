//
//  ProductRepository.swift
//  Products Viewer
//
//  Created by Abdelrahman on 08/03/2023.
//

import Foundation
import CoreData
import UIKit

class ProductRepository {
    private let apiService = PorductService()
    
    func getProducts(delegate: RequestDelegate){
        
        let products =  getDataFromCoreData()
        if products.count > 0{
            delegate.updateState(with: .success(products))
        }else{
            delegate.updateState(with: .loading)
            apiService.getOnlineProducts { response in
                switch response {
                case let .success(products):
                    self.saveDataInCoreData(data: products)
                    delegate.updateState(with: .success(self.getDataFromCoreData()))
                    
                case let .failure(error):
                    delegate.updateState(with: .error(error))
                }
            }
        }
    }
    
    private func saveDataInCoreData(data products: [Products]){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)
            else {
                return
            }
            
            for product in products {
                let newValue = NSManagedObject(entity: entity, insertInto: context)
                newValue.setValue(product.product.id, forKey: "id")
                newValue.setValue(product.product.name, forKey: "name")
                newValue.setValue(product.product.description, forKey: "desc")
                newValue.setValue(product.product.price, forKey: "price")
                newValue.setValue(product.product.imageURL, forKey: "imageURL")
            }
            
            do {
                try context.save()
                print("saving success")
            }catch {
                print("saving failed \(error)")
            }
            
        }
    }
    
    private func getDataFromCoreData() -> [Product]{
        var products = [Product]()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let retrieveRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
            
            do {
                let retrievedProducts = try context.fetch(retrieveRequest)
                print("retrievedProducts.count------>\(retrievedProducts.count)")
                products = mapFromEntityList(entities : retrievedProducts)
            }catch {
                print("retrieving failed \(error)")
            }
            
        }
        return products
    }
    
    private func mapFromEntityList(entities : [ProductEntity]) -> [Product]{
        return entities.map { productEntity in
            mapFromEntity(entity : productEntity)
        }
    }
    
    private func mapFromEntity(entity : ProductEntity) -> Product{
        return Product(id: entity.id!, name: entity.name!, description: entity.desc!, price: entity.price!, imageURL: entity.imageURL!)
    }
    
}
