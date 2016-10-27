//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACSubject;

@protocol Signalable <NSObject>

@required
- (RACSignal *)createSignal;
- (void)subject:(RACSubject *)subject;

@end
