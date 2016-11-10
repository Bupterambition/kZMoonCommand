//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "kZMoonCancelable.h"

typedef void(^kZMoonCancelBlock)(void);

@interface BlockCancelable : NSObject <kZMoonCancelable>

- (instancetype)initWithBlock:(kZMoonCancelBlock)block;

@end
