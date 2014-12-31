//
//  Node.m
//  Vlow
//
//  Created by Joseph Constantakis on 12/31/14.
//  Copyright (c) 2014 Chelseph. All rights reserved.
//

#import "VlowNode.h"
#import "ObjectiveSugar.h"
#import "ReactiveCocoa.h"

@implementation VlowNode

+ (instancetype)node:(NSString *)name
{
    return [self nodeWithName:name outLinks:@[]];
}

+ (instancetype)nodeWithName:(NSString *)name outLinks:(NSArray *)nodes
{
    VlowNode *node = [VlowNode new];
    node.name = name;
    node.outs = nodes;
    return node;
}

+ (instancetype)chain:(NSArray *)nodes
{
    return [[nodes reverse]
    reduce:^VlowNode *(VlowNode *acc, VlowNode *next) {
        return [next connect:acc];
    }];
}

- (VlowNode *)connect:(VlowNode *)next
{
    self.outs = [self.outs arrayByAddingObject:next];
    return self;
}

- (NSString *)description
{
    NSString *suffix =
    self.outs.count == 0 ? @""
    : self.outs.count == 1 ? [@" -> " stringByAppendingString:[self.outs[0] description]]
    : [NSString stringWithFormat:@" -> (%@)", [[self.outs
                                               valueForKey:@keypath(self, description)]
                                               join:@", "]];
    
    return [self.name stringByAppendingString:suffix];
}

@end
