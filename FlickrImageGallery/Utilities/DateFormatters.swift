//
//  DateFormatters.swift
//  FlickrImageGallery
//
//  Created by Mark Wells on 12/10/23.
//

import Foundation

@MainActor
class DateFormatters {
    
    static let shared = DateFormatters()

    let flickrImageDateFormatter: DateFormatter
    
    private init() {
        flickrImageDateFormatter = DateFormatter()
        flickrImageDateFormatter.dateStyle = .short
    }
}
