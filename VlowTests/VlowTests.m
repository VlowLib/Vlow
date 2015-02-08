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
    VlowNode *ps1 = VLO(@"pitchshift");
    VlowNode *chainHead = [VlowNode chain:@[VlowIn, ps1, VlowOut]];
    XCTAssert([chainHead.description isEqualToString:@"vlowin -> pitchshift -> vlowout"],
              @"chain description");
    
    XCTAssertNotEqualObjects(chainHead.outs[0], ps1);
}

//- (void)testPureDataConversion
//{
//    VlowNode *chain = [VlowNode chain:@[VlowIn, VLO(@"pitchshift~"), VlowOut]];
//    NSLog(@"pd:\n\n%@\n\n", [chain pureDataPatch]);
//    XCTAssertEqual(YES, YES, @"pd output should equal fixture");
//}

@end
