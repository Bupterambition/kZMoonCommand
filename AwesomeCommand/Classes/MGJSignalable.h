//
// Created by Zephyrleaves on 16/5/31.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACSubject;

@protocol MGJSignalable <NSObject>

@required
- (RACSignal *)createSignal;
- (void)subject:(RACSubject *)subject;

@end