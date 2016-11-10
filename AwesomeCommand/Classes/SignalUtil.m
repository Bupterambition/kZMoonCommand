//
// Created by  on 16/5/31.
//

#import "SignalUtil.h"
#import "AwesomeCommand.h"
#import "AwesomeResult.h"
#import "AwesomeCancelable.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pthread/pthread.h>

@interface AwesomeEasyResultImpl : NSObject <AwesomeEasyResult>

@property(readonly, nonnull, strong) id<AwesomeResult> result;

+ (instancetype)resultWithResult:(id<AwesomeResult>)result;

@end

@implementation AwesomeEasyResultImpl

- (instancetype)initWithResult:(nonnull id<AwesomeResult>)result {
    self = [super init];
    if (self) {
        _result = result;
    }

    return self;
}

+ (instancetype)resultWithResult:(nonnull id<AwesomeResult>)result {
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


@interface AwesomeResultImpl : NSObject <AwesomeResult>

@property(readonly, nonnull, strong) id<RACSubscriber> subscriber;

+ (instancetype)resultWithSubscriber:(nonnull id<RACSubscriber>)subscriber;

@end

@implementation AwesomeResultImpl
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

- (id<AwesomeEasyResult>)useEasyResult {
    return [AwesomeEasyResultImpl resultWithResult:self];
}

@end


@implementation SignalUtil

+ (RACSignal *)createSignal:(nonnull AwesomeCommand *)command {
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
            
            id<AwesomeResult> result = [AwesomeResultImpl resultWithSubscriber:subscriber];
            [command setValue:@(YES) forKey:@"Executing"];
            id<AwesomeCancelable> cancelable = [command run:result];
            
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
