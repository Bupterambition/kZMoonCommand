//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>

@protocol AwesomeCancelable <NSObject>

@property (atomic, assign, getter = isCanceled, readonly) BOOL canceled;

//取消操作
- (void)cancel;

@end
