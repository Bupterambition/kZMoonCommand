//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>


@protocol AwesomeCallback;
@protocol AwesomeCancelable;
@protocol AwesomeExecutable;

typedef void (^AwesomeExcuteCallbaclBlock)(id<AwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted);

@protocol AwesomeExecutable <NSObject>

@required

@property (nonatomic, assign, readonly) BOOL executing;

- (id<AwesomeCancelable>)executeWithCallback:(id<AwesomeCallback>)callback NS_REQUIRES_SUPER;
- (id<AwesomeCancelable>)executeWithBlock:(AwesomeExcuteCallbaclBlock)callbackBlock NS_REQUIRES_SUPER;

@end
