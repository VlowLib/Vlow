//
//  VlowAudioController.m
//  Vlow
//
//  Created by Joseph Constantakis on 1/1/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import "VlowAudioController.h"
#import "PdAudioController.h"

@implementation VlowAudioController

+ (instancetype)sharedInstance
{
    static VlowAudioController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setupController
{
    self.controller = [PdAudioController new];
    [self.controller configurePlaybackWithSampleRate:44100
                                      numberChannels:2
                                        inputEnabled:YES
                                       mixingEnabled:YES];
//    if (status == PdAudioError) {
//        NSLog(@"Error! Could not configure PdAudioController");
//    } else if (status == PdAudioPropertyChanged) {
//        NSLog(@"Warning: some of the audio parameters were not accceptable.");
//    } else {
//        NSLog(@"Audio Configuration successful.");
//    }
    self.controller.active = YES;
}

@end
