//
// Created by Wentong on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol MGJAwesomeCancelable;
@protocol MGJAwesomeResult;

@protocol MGJAwesomeAsyncRunnable <NSObject>

@required
- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result;

@end