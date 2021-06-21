//
//  JRKitTests.swift
//  JRKitTests
//
//  Created by jackfrow on 2021/5/31.
//

import XCTest
@testable import JRKit

class JRKitTests: XCTestCase {

    
    func testUUID() {
        
//        F6131420-0CE7-4E14-9824-0F295A5CE5C5
        
        let uuid1 = JRUUID.GetUUID()
        print("uuid1",uuid1)
    
        let uuid2 = JRUUID.GetUUID()
        
        print("uuid2",uuid2)
    
        let uuid3 = JRUUID.GetUUID()
        print("uuid3",uuid3)
        
        XCTAssert(uuid1 == uuid2,"invalid GetUUID")
        XCTAssert(uuid2 == uuid3,"invalid GetUUID")
    
    }

}
