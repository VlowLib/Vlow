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
#import "PdBase.h"
#import "PdFile.h"
#import "VlowPureDataConverter.h"
#import "VlowAudioController.h"

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
    node.patch = [PdFile openFileNamed:[name stringByAppendingString:@".pd"]
                                  path:[[NSBundle mainBundle] resourcePath]];
    if (![VlowAudioController sharedInstance].controller) {
        [[VlowAudioController sharedInstance] setupController];
    }
    return node;
}

+ (instancetype)chain:(NSArray *)nodes
{
    VlowNode *acc = nodes.lastObject;
    NSEnumerator *reversed = nodes.reverseObjectEnumerator;
    for (VlowNode *next in reversed) {
        if (next != acc) {
            acc = [next connect:acc];
        }
    }
    return acc;
}

- (VlowNode *)connect:(VlowNode *)next
{
    self.outs = [self.outs arrayByAddingObject:next];
    
    NSString *receiver = [NSString stringWithFormat:@"vlow-router-%d",
                          self.patch.dollarZero];
    NSString *message  = [NSString stringWithFormat:@"%d",
                          next.patch.dollarZero];
    [PdBase sendSymbol:message toReceiver:receiver];
    
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

- (void)bindParameter:(NSString *)paramName toSignal:(RACSignal *)signal
{
    [signal subscribeNext:^(id value) {
        [self setParameter:paramName toValue:value];
    }];
}

- (void)setParameter:(NSString *)paramName toValue:(id)value
{
    if (!value || !paramName || paramName.length == 0) {
        return;
    }
    NSString *receiver = [NSString stringWithFormat:@"%@-%d",
                          paramName, self.patch.dollarZero];
    if ([value isKindOfClass:[NSNumber class]]) {
        [PdBase sendFloat:[value floatValue] toReceiver:receiver];
    } else if ([value isKindOfClass:[NSString class]]) {
        [PdBase sendMessage:value withArguments:nil
                 toReceiver:receiver];
    } else if ([value isKindOfClass:[NSArray class]]) {
        [PdBase sendList:value toReceiver:receiver];
    }
}

//- (void)startPatch
//{
//    [PdBase addToSearchPath:[[NSBundle mainBundle] resourcePath]];
//    [PdBase addToSearchPath:NSTemporaryDirectory()];
//    NSURL *patchURL = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES]
//                       URLByAppendingPathComponent:kPatchFileName];
//    
//    [[self pureDataPatch] writeToURL:patchURL
//                          atomically:YES
//                            encoding:NSASCIIStringEncoding
//                               error:NULL];
//    
//    [PdBase openFile:kPatchFileName path:NSTemporaryDirectory()];
//}
//
//#pragma mark - PureData
//
//- (NSString *)pureDataPatch
//{
//    return [VlowPureDataConverter pureDataPatchFromGraph:self];
//}

@end
