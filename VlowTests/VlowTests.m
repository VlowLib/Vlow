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

- (void)testChain
{
    VlowNode *chain = [VlowNode chain:@[VlowIn, VLO(@"pitchshift~"), VlowOut]];
    NSLog(@"chain: %@", chain);
    XCTAssert([chain.description isEqualToString:@"adc~ -> pitchshift~ -> dac~"],
              @"chain description");
}

- (void)testPureDataConversion
{
    VlowNode *chain = [VlowNode chain:@[VlowIn, VLO(@"pitchshift~"), VlowOut]];
    NSLog(@"pd:\n\n%@\n\n", [chain pureDataPatch]);
    XCTAssertEqual(YES, YES, @"pd output should equal fixture");
}

@end
