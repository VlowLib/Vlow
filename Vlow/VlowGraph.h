//
//  VlowGraph.h
//  Vlow
//
//  Created by Joseph Constantakis on 4/9/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VlowGraph : NSObject

@property (nonatomic, strong) NSArray *nodes;

- (id)initWithNodes:(NSArray *)nodes;

@end
