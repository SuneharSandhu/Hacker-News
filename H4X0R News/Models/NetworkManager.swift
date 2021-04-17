//
//  NetworkManager.swift
//  H4X0R News
//
//  Created by Sunehar Sandhu on 12/11/20.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    let baseUrl = "http://hn.algolia.com/api/v1/search?tags=front_page"
    
    func fetchData() {
        if let url = URL(string: baseUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
