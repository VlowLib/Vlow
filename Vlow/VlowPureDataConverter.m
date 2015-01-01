//
//  VlowPureDataConverter.m
//  
//
//  Created by Joseph Constantakis on 1/1/15.
//
//

#import "VlowPureDataConverter.h"
#import "ObjectiveSugar.h"

@implementation VlowPureDataConverter

+ (NSString *)pureDataPatchFromGraph:(VlowNode *)root
{
    // TODO: get working for graphs with loops,
    // multiple nodes w/ same name,
    // and multiple root nodes
    NSMutableDictionary *positions    = [NSMutableDictionary dictionary];
    NSMutableDictionary *ids          = [NSMutableDictionary dictionary];
    NSMutableDictionary *nodesAtDepth = [@{@0: @1} mutableCopy];
    NSMutableArray *objectLines       = [NSMutableArray arrayWithObject:
                                         [self objectLineForName:root.name
                                                             pos:CGPointZero]];
    NSMutableArray *edgeLines         = [NSMutableArray array];
    NSMutableArray *nodeQueue         = [NSMutableArray arrayWithObject:self];
    
    __block CGPoint southEastPoint = CGPointZero;
    __block int runningID          = 0;
    ids[root.name]                 = @(runningID++);
    positions[root.name]           = [NSValue valueWithCGPoint:CGPointZero];
    
    while (nodeQueue.count > 0) {
        VlowNode *parent = nodeQueue.firstObject;
        [nodeQueue removeObjectAtIndex:0];
        
        NSNumber *parentID = ids[root.name];
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
            
            ids[root.name] = @(runningID++);
        }];
        nodesAtDepth[@(y)] = @(x);
    }
    NSString *canvasLine = [self canvasLineForSEPoint:southEastPoint];
    NSArray *lines = [@[canvasLine, objectLines, edgeLines] flatten];
    return [lines join];
}

const int patchSpacing = 30;

+ (NSString *)canvasLineForSEPoint:(CGPoint)pt
{
    return [NSString stringWithFormat:@"#N canvas 0 0 %d %d vlowpatch;\n",
            (int)((pt.x+1) * patchSpacing), (int)((pt.y+1) * patchSpacing)];
}

+ (NSString *)objectLineForName:(NSString *)name pos:(CGPoint)pos
{
    return [NSString stringWithFormat:@"#X obj %d %d %@;\n",
            (int)(pos.x * patchSpacing), (int)(pos.y * patchSpacing), name];
}

+ (NSString *)edgeLineForSource:(NSNumber *)src dest:(NSNumber *)dest
{
    return [NSString stringWithFormat:@"#X connect %d 0 %d 0;\n",
            [src intValue], [dest intValue]];
}

@end
