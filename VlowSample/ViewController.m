//
//  ViewController.m
//  VlowSample
//
//  Created by Joseph Constantakis on 4/9/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import "Vlow.h"
#import "ViewController.h"
#import "VlowGraph.h"

@interface ViewController ()
{
    VlowGraph *g;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    g = [[VlowGraph alloc] initWithNodes:@[VlowIn, VlowOut]];
}

@end
