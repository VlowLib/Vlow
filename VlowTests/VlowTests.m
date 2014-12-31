//
//  VlowTests.m
//  VlowTests
//
//  Created by Joseph Constantakis on 12/31/14.
//  Copyright (c) 2014 Chelseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VlowNode.h"

@interface VlowTests : XCTestCase

@end

@implementation VlowTests

- (void)testExample
{
    VlowNode *chain = [VlowNode chain:@[VlowIn, VLO(@"pitchshift~"), VlowOut]];
    XCTAssertEqual(chain.description,
                   @"adc~ -> pitchshift~ -> dac~",
                   @"chain description");
}

@end
