//
//  NetworkManager.swift
//  Technical Interview Hector
//
//  Created by Hector Rodriguez on 1/12/23.
//

import UIKit
import Combine

public enum Endpoint: String{
    case topics = "https://tenpercent-interview-project.s3.amazonaws.com/topics.json"
    case subtopics = "https://tenpercent-interview-project.s3.amazonaws.com/subtopics.json"
    case meditations = "https://tenpercent-interview-project.s3.amazonaws.com/meditations.json"
}

enum NetworkingError: Error {
    case invalidURL
    case timeOut
    case unknownError
    case none
}

public class NetworkingManager{
    static let shared = NetworkingManager()
    
    var imageCache = NSCache<AnyObject, UIImage>()
    let imageQueue = DispatchQueue(label: "imageQueue", qos: .userInitiated)
    
    var topics: [Topic]?
    var subtopics: [Subtopic]?
    var meditations: [Meditation]?
    
    
    public init(){}
    
    func loadContentData(completion: @escaping ()->()){
        Task{
            do{
                self.topics = try await getDataFrom(endpoint: .topics, type: Topics.self)?
                    .topics.filter({$0.featured})
                    .sorted(by: {$0.position > $1.position})
                
                self.subtopics = try await getDataFrom(endpoint: .subtopics, type: Subtopics.self)?.subtopics
                
                self.meditations = try await getDataFrom(endpoint: .meditations, type: Meditations.self)?.meditations
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func loadImage (urlString: String) async throws -> UIImage?  {
        if (urlString.contains("/assets")){
            let assetName = urlString.replacingOccurrences(of: "/assets/", with: "")
            return UIImage(named: assetName)
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) {
            return cachedImage
        }
        
        guard let imageURL = URL(string: urlString) else {return nil}
        
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        guard let image = UIImage(data: data) else {return nil}
        self.imageCache.setObject(image, forKey: imageURL as AnyObject)
        return image
    }
}

fileprivate extension NetworkingManager {
    func getDataFrom<T: Codable>(endpoint: Endpoint, type: T.Type) async throws -> T?{
        if let storedData = loadDataFromUserDefaults(endpoint: endpoint, type: T.self) {
            return storedData
        }
        guard let url = URL(string: endpoint.rawValue) else{
            throw NetworkingError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let value = try decoder.decode(T.self, from: data)
            self.saveDataInUserDefaults(endpoint: endpoint, value: value)
            return value
          }
          catch {
            return nil
          }
    }
    
    func loadDataFromUserDefaults<T: Codable>(endpoint: Endpoint, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: endpoint.rawValue) as? Data,
           let object = try? decoder.decode(T.self, from: data) {
            return object
        }
        return nil
    }
    
    func saveDataInUserDefaults(endpoint: Endpoint, value: Codable) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: endpoint.rawValue)
        }
    }
}

