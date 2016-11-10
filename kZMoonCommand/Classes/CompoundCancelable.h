//
//  CompoundCancelable.h
//  Pods
//
//  Created by BupterAmbition on 9/1/16.
//
//

#import <Foundation/Foundation.h>
#import "kZMoonCancelable.h"
#import "BlockCancelable.h"

@interface CompoundCancelable : NSObject <kZMoonCancelable>

- (instancetype)initWithBlock:(kZMoonCancelBlock)block;

- (instancetype)initWithCancelables:(NSArray *)otherCancelables;

- (void)addCancelable:(id<kZMoonCancelable>)cancelable;

- (void)removeCancelable:(id<kZMoonCancelable>)cancelable;

@end
