//
//  ViewController.m
//  VlowSample
//
//  Created by Joseph Constantakis on 4/9/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import "Vlow.h"
#import "ViewController.h"

@interface ViewController ()
{
    VlowNode *chain;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chain = [VlowIn connect:VlowOut];
}

@end
