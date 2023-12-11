//
//  Photo.swift
//  ImageGallery
//
//  Created by Mark Wells on 11/15/23.
//

import Foundation

struct FlickrImage : Decodable, Identifiable, Hashable {
    let title: String
    let link: String
    let url: URL
    let description: String
    let tags: String
    let dateTaken: Date
    let datePublished: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case tags
        case dateTaken = "date_taken"
        case datePublished = "published"
        case media

        enum MediaCodingKeys: String, CodingKey {
            case m
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.tags = try container.decodeIfPresent(String.self, forKey: .tags) ?? ""
        self.dateTaken = try container.decode(Date.self, forKey: .dateTaken)
        self.datePublished = try container.decode(Date.self, forKey: .datePublished)
        let mediaContainer = try container.nestedContainer(keyedBy: CodingKeys.MediaCodingKeys.self, forKey: .media)
        if let url = try URL(string: mediaContainer.decode(String.self, forKey: .m)) {
            self.url = url
        }
        else {
            throw URLError(.badURL)
        }
    }
    
    var id: URL {
        return url
    }
}

struct SearchResponse : Decodable {
    let title: String
    let items: [FlickrImage]
}

