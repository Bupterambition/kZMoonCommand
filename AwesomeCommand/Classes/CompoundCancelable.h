//
//  CompoundCancelable.h
//  Pods
//
//  Created by Senmiao on 9/1/16.
//
//

#import <Foundation/Foundation.h>
#import "AwesomeCancelable.h"
#import "BlockCancelable.h"

@interface CompoundCancelable : NSObject <AwesomeCancelable>

- (instancetype)initWithBlock:(AwesomeCancelBlock)block;

- (instancetype)initWithCancelables:(NSArray *)otherCancelables;

- (void)addCancelable:(id<AwesomeCancelable>)cancelable;

- (void)removeCancelable:(id<AwesomeCancelable>)cancelable;

@end
