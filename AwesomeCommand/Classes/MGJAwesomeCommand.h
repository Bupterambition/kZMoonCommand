//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "MGJAwesomeExecutable.h"
#import "MGJSignalable.h"
#import "MGJAwesomeAsyncRunnable.h"

typedef id<MGJAwesomeCancelable> (^MGJAwesomeExcuteBlock)(id<MGJAwesomeResult> result);

@protocol MGJAwesomeCommand <MGJAwesomeExecutable, MGJSignalable, MGJAwesomeAsyncRunnable, MGJAwesomeCancelable>

/** 无须处理，创建signal时内部管理 */
@property (nonatomic, strong, readonly) dispatch_queue_t callbackQueue;
/** 构建新类时内部处理 */
@property (nonatomic, strong, readonly) dispatch_queue_t excuteQueue;

@optional
@property (nonatomic, copy) MGJAwesomeExcuteBlock excuteBlock;

@end

// user should override - (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result;
@interface MGJAwesomeCommand : NSObject <MGJAwesomeCommand>

@end