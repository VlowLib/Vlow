//
//  VlowTests.swift
//  VlowTests
//
//  Created by Joseph Constantakis on 12/27/14.
//
//

import UIKit
import XCTest
import Vlow

class VlowTests: XCTestCase {
    
    func testNode() {
        let node = Node("test")
        let chain = InputNode() ~~> Vlow.Node("pitchshift~") ~~> Vlow.OutputNode()
        println(chain)
        XCTAssertEqual(1, 1);
    }
}
