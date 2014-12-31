//
//  Node.h
//  Vlow
//
//  Created by Joseph Constantakis on 12/31/14.
//  Copyright (c) 2014 Chelseph. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLO(X) [VlowNode node:X]
#define VlowIn VLO(@"adc~")
#define VlowOut VLO(@"dac~")

@interface VlowNode : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *outs;

+ (instancetype)node:(NSString *)name;
+ (instancetype)nodeWithName:(NSString *)name outLinks:(NSArray *)nodes;
+ (instancetype)chain:(NSArray *)nodes;

///	Connect the receiver's output to the
/// input of `next`, and returns the receiver
- (VlowNode *)connect:(VlowNode *)next;

- (void)startPatch;

- (NSString *)pureDataPatch;

@end
