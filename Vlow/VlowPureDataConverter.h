//
//  VlowPureDataConverter.h
//  
//
//  Created by Joseph Constantakis on 1/1/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VlowNode.h"

@interface VlowPureDataConverter : NSObject

+ (NSString *)pureDataPatchFromRootNode:(VlowNode *)root;

@end
