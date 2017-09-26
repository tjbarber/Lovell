//
//  LovellTests.swift
//  LovellTests
//
//  Created by TJ Barber on 9/13/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import XCTest
@testable import Lovell

class LovellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHubbleImageData() {
        let expectation = XCTestExpectation(description: "We get at least one page of data from Hubble.")
        
        HubbleAPI.sharedInstance.getImageData(page: 1) { metadata, error in
            if let _ = error {
                XCTFail()
            }
            
            guard let metadata = metadata else {
                XCTFail()
                return
            }
            
            XCTAssert(metadata.count > 0, "No data was returned from the server!")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testMarsRoverData() {
        let expectation = XCTestExpectation(description: "We get valid data from the Mars Rover API")
        
        MarsRoverAPI.sharedInstance.getImageMetadataFrom(.curiosity, camera: .fhaz, sol: 1000) { metadata, error in
            if let _ = error {
                XCTFail()
            }
            
            guard let metadata = metadata else {
                XCTFail()
                return
            }
            
            XCTAssert(metadata.count > 0, "No data was returned from the server!")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testEarthImageryAssetList() {
        let expectation = XCTestExpectation(description: "We need to get an asset list from the Earth Imagery API")
        
        EarthImageryAPI.sharedInstance.getAssetList(lat: 33.0, long: 33.0) { assets, error in
            if let _ = error {
                XCTFail()
            }
            
            guard let assets = assets else {
                XCTFail()
                return
            }
            
            XCTAssert(assets.count > 0, "No data was returned from the server!")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testEarthImageryData() {
        let expectation = XCTestExpectation(description: "We need to get image metadata from the Earth Imagery API")
        let latitude = 33.0
        let longitude = 33.0
        let expectedId = "LC8_L1T_TOA/LC81750372016121LGN00"
        EarthImageryAPI.sharedInstance.getAssetList(lat: latitude, long: longitude) { assets, error in
            if let _ = error {
                XCTFail()
            }
            
            guard let assets = assets else {
                XCTFail()
                return
            }
            
            guard let latestAsset = assets.last else {
                XCTFail()
                return
            }
            
            EarthImageryAPI.sharedInstance.getEarthImage(lat: latitude, long: longitude, asset: latestAsset) { imageData, error in
                if let _ = error {
                    XCTFail()
                }
                
                guard let imageData = imageData else {
                    XCTFail()
                    return
                }
                
                XCTAssert(imageData.id == expectedId, "The image data recieved was not what we expected!")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFileDownload() {
        let expectation = XCTestExpectation(description: "We should be able to download a file.")
        let api = API()
        
        api.downloadFile("https://www.wikipedia.org/portal/wikipedia.org/assets/img/Wikipedia-logo-v2.png", queryItems: nil) { data, error in
            if let _ = error {
                XCTFail()
            }
            
            guard let data = data else {
                XCTFail()
                return
            }
            
            let image = UIImage(data: data)
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
}
