//
//  Node.h
//  Vlow
//
//  Created by Joseph Constantakis on 12/31/14.
//  Copyright (c) 2014 Chelseph. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VLO(X) [VlowNode node:X]
#define VlowIn VLO(@"vlowin")
#define VlowOut VLO(@"vlowout")

@class PdFile, RACSignal;

@interface VlowNode : NSObject <NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PdFile *patch;

+ (instancetype)node:(NSString *)name;

- (void)setParameter:(NSString *)paramName toValue:(id)value;
- (void)bindParameter:(NSString *)paramName toSignal:(RACSignal *)signal;

@end
