//
//  MGJCompoundCancelable.h
//  Pods
//
//  Created by Derek Chen on 9/1/16.
//
//

#import <Foundation/Foundation.h>
#import "MGJAwesomeCancelable.h"
#import "MGJBlockCancelable.h"

@interface MGJCompoundCancelable : NSObject <MGJAwesomeCancelable>

- (instancetype)initWithBlock:(MGJAwesomeCancelBlock)block;

- (instancetype)initWithCancelables:(NSArray *)otherCancelables;

- (void)addCancelable:(id<MGJAwesomeCancelable>)cancelable;

- (void)removeCancelable:(id<MGJAwesomeCancelable>)cancelable;

@end
