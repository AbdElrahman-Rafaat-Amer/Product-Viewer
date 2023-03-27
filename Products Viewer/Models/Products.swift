//
//  Products.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation
import CoreData

struct Products: Decodable{
    let product : Product
    
    enum CodingKeys: String, CodingKey {
        case product = "Product"
    }
}


struct Product: Decodable{
    let id : String
    let name : String
    let description : String
    let price : String
    let imageURL : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
        case imageURL = "image_url"
    }
    
    init(id: String, name: String, description: String, price: String, imageURL: String) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
    }
}



