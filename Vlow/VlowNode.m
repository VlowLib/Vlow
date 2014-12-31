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

- (void)startPatch
{
    
}

#pragma mark - PureData

- (NSString *)pureDataPatch
{
    // TODO: get working for graphs with loops,
    // multiple nodes w/ same name,
    // and multiple root nodes
    NSMutableDictionary *positions    = [NSMutableDictionary dictionary];
    NSMutableDictionary *ids          = [NSMutableDictionary dictionary];
    NSMutableDictionary *nodesAtDepth = [@{@0: @1} mutableCopy];
    NSMutableArray *objectLines       = [NSMutableArray arrayWithObject:
                                         [self objectLineForName:self.name
                                                             pos:CGPointZero]];
    NSMutableArray *edgeLines         = [NSMutableArray array];
    NSMutableArray *nodeQueue         = [NSMutableArray arrayWithObject:self];
    
    __block CGPoint southEastPoint = CGPointZero;
    __block int runningID          = 0;
    ids[self.name]                 = @(runningID++);
    positions[self.name]           = [NSValue valueWithCGPoint:CGPointZero];
    
    while (nodeQueue.count > 0) {
        VlowNode *parent = nodeQueue.firstObject;
        [nodeQueue removeObjectAtIndex:0];
        
        NSNumber *parentID = ids[self.name];
        CGPoint parentPos  = [positions[parent.name] CGPointValue];
        int y              = parentPos.y + 1;
        __block int x      = [(nodesAtDepth[@(y)] ?: @0) intValue];
        
        [parent.outs eachWithIndex:^(VlowNode *child, NSUInteger i) {
            [nodeQueue addObject:child];
        
            CGPoint pos = southEastPoint = CGPointMake(x++, y);
            positions[child.name] = [NSValue valueWithCGPoint:pos];
            
            [objectLines addObject:[self objectLineForName:child.name
                                                       pos:pos]];
            [edgeLines addObject:[self edgeLineForSource:parentID
                                                    dest:@(runningID)]];
            
            ids[self.name] = @(runningID++);
        }];
        nodesAtDepth[@(y)] = @(x);
    }
    NSString *canvasLine = [self canvasLineForSEPoint:southEastPoint];
    NSArray *lines = [@[canvasLine, objectLines, edgeLines] flatten];
    return [lines join];
}

const int patchSpacing = 30;

- (NSString *)canvasLineForSEPoint:(CGPoint)pt
{
    return [NSString stringWithFormat:@"#N canvas 0 0 %d %d vlowpatch;\n",
            (int)((pt.x+1) * patchSpacing), (int)((pt.y+1) * patchSpacing)];
}

- (NSString *)objectLineForName:(NSString *)name pos:(CGPoint)pos
{
    return [NSString stringWithFormat:@"#X obj %d %d %@;\n",
            (int)(pos.x * patchSpacing), (int)(pos.y * patchSpacing), name];
}

- (NSString *)edgeLineForSource:(NSNumber *)src dest:(NSNumber *)dest
{
    return [NSString stringWithFormat:@"#X connect %d 0 %d 0;\n",
            [src intValue], [dest intValue]];
}

@end
