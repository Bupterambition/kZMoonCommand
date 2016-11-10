//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "kZMoonExecutable.h"
#import "Signalable.h"
#import "kZMoonAsyncRunnable.h"

typedef id<kZMoonCancelable> (^kZMoonExcuteBlock)(id<kZMoonResult> result);

@protocol kZMoonCommand <kZMoonExecutable, Signalable, kZMoonAsyncRunnable, kZMoonCancelable>

/** 无须处理，创建signal时内部管理 */
@property (nonatomic, strong, readonly) dispatch_queue_t callbackQueue;
/** 构建新类时内部处理 */
@property (nonatomic, strong, readonly) dispatch_queue_t excuteQueue;

@optional
@property (nonatomic, copy) kZMoonExcuteBlock excuteBlock;

@end

// user should override - (id<kZMoonCancelable>)run:(id<kZMoonResult>)result;
@interface kZMoonCommand : NSObject <kZMoonCommand>

@end
