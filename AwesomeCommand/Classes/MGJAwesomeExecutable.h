//
// Created by Wentong on 16/5/31.
//

#import <Foundation/Foundation.h>


@protocol MGJAwesomeCallback;
@protocol MGJAwesomeCancelable;
@protocol MGJAwesomeExecutable;

typedef void (^MGJAwesomeExcuteCallbaclBlock)(id<MGJAwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted);

@protocol MGJAwesomeExecutable <NSObject>

@required

@property (nonatomic, assign, readonly) BOOL executing;

- (id<MGJAwesomeCancelable>)executeWithCallback:(id<MGJAwesomeCallback>)callback NS_REQUIRES_SUPER;
- (id<MGJAwesomeCancelable>)executeWithBlock:(MGJAwesomeExcuteCallbaclBlock)callbackBlock NS_REQUIRES_SUPER;

@end