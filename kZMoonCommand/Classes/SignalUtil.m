//
// Created by BupterAmbition on 16/5/31.
//

#import "SignalUtil.h"
#import "kZMoonCommand.h"
#import "kZMoonResult.h"
#import "kZMoonCancelable.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pthread/pthread.h>

@interface kZMoonEasyResultImpl : NSObject <kZMoonEasyResult>

@property(readonly, nonnull, strong) id<kZMoonResult> result;

+ (instancetype)resultWithResult:(id<kZMoonResult>)result;

@end

@implementation kZMoonEasyResultImpl

- (instancetype)initWithResult:(nonnull id<kZMoonResult>)result {
    self = [super init];
    if (self) {
        _result = result;
    }

    return self;
}

+ (instancetype)resultWithResult:(nonnull id<kZMoonResult>)result {
    return [[self alloc] initWithResult:result];
}

- (void)onSuccess:(id)data {
    [_result onNext:data];
    [_result onComplete];
}

- (void)onError:(NSError *)error {
    [_result onError:error];
}

@end


@interface kZMoonResultImpl : NSObject <kZMoonResult>

@property(readonly, nonnull, strong) id<RACSubscriber> subscriber;

+ (instancetype)resultWithSubscriber:(nonnull id<RACSubscriber>)subscriber;

@end

@implementation kZMoonResultImpl
- (instancetype)initWithSubscriber:(nonnull id<RACSubscriber>)subscriber {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
    }
    return self;
}

+ (instancetype)resultWithSubscriber:(id<RACSubscriber>)subscriber {
    return [[self alloc] initWithSubscriber:subscriber];
}


- (void)onNext:(id)data {
    [_subscriber sendNext:data];
}

- (void)onComplete {
    [_subscriber sendCompleted];

}

- (void)onError:(NSError *)error {
    [_subscriber sendError:error];
}

- (id<kZMoonEasyResult>)useEasyResult {
    return [kZMoonEasyResultImpl resultWithResult:self];
}

@end


@implementation SignalUtil

+ (RACSignal *)createSignal:(nonnull kZMoonCommand *)command {
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_t _mutex;
    const int result = pthread_mutex_init(&_mutex, NULL);
    NSCAssert(0 == result, @"Failed to initialize mutex with error %d.", result);
    
    @weakify(command);
    RACSignal *racSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(command);
        if (command && [command respondsToSelector:@selector(run:)]) {
            pthread_mutex_lock(&_mutex);
            
            id<kZMoonResult> result = [kZMoonResultImpl resultWithSubscriber:subscriber];
            [command setValue:@(YES) forKey:@"Executing"];
            id<kZMoonCancelable> cancelable = [command run:result];
            
            pthread_mutex_unlock(&_mutex);
            if (cancelable) {
                return [RACDisposable disposableWithBlock:^{
                    [cancelable cancel];
                }];
            } else {
                return nil;
            }
            
        }
        return nil;
    }];

    return racSignal;

}
@end
