//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol AwesomeCancelable;
@protocol AwesomeResult;

@protocol AwesomeAsyncRunnable <NSObject>

@required
- (id<AwesomeCancelable>)run:(id<AwesomeResult>)result;

@end
