//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol kZMoonCancelable;
@protocol kZMoonResult;

@protocol kZMoonAsyncRunnable <NSObject>

@required
- (id<kZMoonCancelable>)run:(id<kZMoonResult>)result;

@end
