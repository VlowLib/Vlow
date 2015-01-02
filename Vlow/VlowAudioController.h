//
//  VlowAudioController.h
//  Vlow
//
//  Created by Joseph Constantakis on 1/1/15.
//  Copyright (c) 2015 Chelseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PdAudioController;

@interface VlowAudioController : NSObject

@property (nonatomic, strong) PdAudioController *controller;

+ (instancetype)sharedInstance;
- (void)setupController;

@end
