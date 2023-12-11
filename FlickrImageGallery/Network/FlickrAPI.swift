//
//  Network.swift
//  ImageGallery
//
//  Created by Mark Wells on 11/15/23.
//

import SwiftUI

class FlickrAPI {
    
    public static var shared = FlickrAPI()
    
    private let searchUrl = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    
    private init() {}
    
    public func search(_ tags: String) async -> SearchResponse? {
        
        let urlString = searchUrl + tags
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode(SearchResponse.self, from: data)
            return response
        }
        catch {
            print("Exception thrown fetching photos from URL: \(urlString)\nError: \(error)")
            return nil
        }
    }
}


