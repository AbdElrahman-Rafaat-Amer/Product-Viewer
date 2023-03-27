//
//  ProductService.swift
//  Products Viewer
//
//  Created by Abdelrahman on 01/03/2023.
//

import Foundation

class PorductService{
    
    private let productsURL = "http://www.nweave.com/wp-content/uploads/2012/09/featured.txt"
    
    func getOnlineProducts(completion : @escaping (Result<[Products], Error>) -> ()) {
        print("PorductService in getOnlineProducts")
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL(string:productsURL)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { (data, response, error) in
            print("Got response")
            if let dataValue = data{
                if let productsResponse = try? JSONDecoder().decode([Products].self, from: dataValue) {
                    completion(.success(productsResponse))
                } else {
                    print("Invalid Response")
                }
            }
            if let errorMessage = error{
                print("errorValue-----> \(errorMessage)")
                completion(.failure(errorMessage))
            }
        }
        task.resume()
    }
    
}
