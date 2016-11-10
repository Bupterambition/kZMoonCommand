//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "AwesomeExecutable.h"
#import "Signalable.h"
#import "AwesomeAsyncRunnable.h"

typedef id<AwesomeCancelable> (^AwesomeExcuteBlock)(id<AwesomeResult> result);

@protocol AwesomeCommand <AwesomeExecutable, Signalable, AwesomeAsyncRunnable, AwesomeCancelable>

/** 无须处理，创建signal时内部管理 */
@property (nonatomic, strong, readonly) dispatch_queue_t callbackQueue;
/** 构建新类时内部处理 */
@property (nonatomic, strong, readonly) dispatch_queue_t excuteQueue;

@optional
@property (nonatomic, copy) AwesomeExcuteBlock excuteBlock;

@end

// user should override - (id<AwesomeCancelable>)run:(id<AwesomeResult>)result;
@interface AwesomeCommand : NSObject <AwesomeCommand>

@end
