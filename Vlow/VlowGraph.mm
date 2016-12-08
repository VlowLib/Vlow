//
//  VlowGraph.m
//  Vlow
//
//  Created by Joseph Constantakis on 4/9/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import <libpd/PdAudioController.h>
#import <libpd/PdBase.h>
#import <libpd/PdFile.h>
#import "VlowGraph.h"
#import "VlowNode.h"

void freeverb_tilde_setup(void);

@interface VlowGraph ()

@property (nonatomic, strong) PdAudioController *controller;

@end

@implementation VlowGraph

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    [self activate];
    
    return self;
}

- (id)initWithNodes:(NSArray *)nodes
{
    if (!(self = [self init]))
        return nil;
    
    self.nodes = nodes;
    
    return self;
}

- (void)setNodes:(NSArray *)nodes
{
    VlowNode *prev = nil;
    for (VlowNode *node in nodes) {
        [node activate];
        if (prev) {
            [self connect:prev to:node];
        }
        prev = node;
    }
    
    _nodes = nodes;
}

- (void)connect:(VlowNode *)from to:(VlowNode *)to
{
    NSString *receiver = [NSString stringWithFormat:@"vlow-router-%d",
                          from.patch.dollarZero];
    NSString *message  = [NSString stringWithFormat:@"%d",
                          to.patch.dollarZero];
    [PdBase sendSymbol:message toReceiver:receiver];
}

- (void)activate
{
    [PdBase addToSearchPath:[[NSBundle bundleForClass:self.class] bundlePath]];

    self.controller = [PdAudioController new];
    PdAudioStatus stat = [self.controller configurePlaybackWithSampleRate:48000
                                                           numberChannels:2
                                                             inputEnabled:YES
                                                            mixingEnabled:YES];
    if (stat == PdAudioError) {
        NSLog(@"Error! Could not configure PdAudioController");
    } else if (stat == PdAudioPropertyChanged) {
        NSLog(@"Warning: some of the audio parameters were not accceptable.");
    } else if (stat == PdAudioOK) {
        NSLog(@"Audio Configuration successful.");
    }
    self.controller.active = YES;
    freeverb_tilde_setup();
}

@end
