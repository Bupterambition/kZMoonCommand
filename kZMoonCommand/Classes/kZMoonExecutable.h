//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>


@protocol kZMoonCallback;
@protocol kZMoonCancelable;
@protocol kZMoonExecutable;

typedef void (^kZMoonExcuteCallbaclBlock)(id<kZMoonExecutable> cmd, id data, NSError *error, BOOL isCompleted);

@protocol kZMoonExecutable <NSObject>

@required

@property (nonatomic, assign, readonly) BOOL executing;

- (id<kZMoonCancelable>)executeWithCallback:(id<kZMoonCallback>)callback NS_REQUIRES_SUPER;
- (id<kZMoonCancelable>)executeWithBlock:(kZMoonExcuteCallbaclBlock)callbackBlock NS_REQUIRES_SUPER;

@end
