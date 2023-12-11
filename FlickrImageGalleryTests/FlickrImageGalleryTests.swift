//
//  FlickrImageGalleryTests.swift
//  FlickrImageGalleryTests
//
//  Created by Mark Wells on 11/19/23.
//

import XCTest
@testable import FlickrImageGallery

final class FlickrImageGalleryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchPorcupine() async throws {
        try await searchAsync(tags: "porcupine")
    }

    func searchAsync(tags: String) async throws {
        let photosResponse = await FlickrAPI.shared.search(tags)
        XCTAssertNotNil(photosResponse, "Nil response received fetching photos")
        if let response = photosResponse {
            XCTAssert(!response.title.isEmpty, "Photos response returned but indicated failure")
            let numPhotos = response.items.count
            XCTAssert(numPhotos > 0, "Incorrect number of photos received")
        }
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
