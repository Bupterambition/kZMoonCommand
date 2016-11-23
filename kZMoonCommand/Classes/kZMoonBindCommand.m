//
//  kZMoonBindCommand.m
//  Pods
//
//  Created by Senmiao on 2016/11/23.
//
//

#import "kZMoonBindCommand.h"
#import "kZMoonCommand+Bind.h"
#import "kZMoonCommandPublicHeader.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface kZMoonBindCommand ()
@property (nonatomic, strong) kZMoonCommand *firstCommand;
@property (nonatomic, strong) NSMutableArray <__kindof kZMoonCommand *> *commandArray;
@property (nonatomic, strong) id<kZMoonCancelable> cancelable;
@end

@implementation kZMoonBindCommand


- (instancetype)initWithCommand:(kZMoonBindCommand *)command {
    self = [super init];
    if (self) {
        self.firstCommand = command;
    }
    return self;
}

- (id<kZMoonCancelable>)_executeWithCallback:(id<kZMoonCallback>)callback andBlock:(kZMoonExcuteCallbaclBlock)callbackBlock  {
    if (callback) {
        NSCParameterAssert([callback conformsToProtocol:@protocol(kZMoonCallback)]);
    }
    [self setValue:@(YES) forKey:@"executing"];
    if ([self valueForKey:@"bindBlockArray"]) {
        NSMutableArray *bindBlocks = [self valueForKey:@"bindBlockArray"];
        RACSignal *firstSignal = [self.firstCommand createSignal];
        RACSignal *eachSignal = firstSignal;
        RACSignal __block *nextSignal = nil;
        kZMoonCommand __block *nextCommand = nil;
        [self.commandArray addObject:self.firstCommand];
        @synchronized (self) {
            for (NSUInteger index = 0; index < bindBlocks.count; index ++) {
                KzMoonBindBlock block = [bindBlocks[index] copy];
                if (block) {
                    eachSignal = [[eachSignal doNext:^(id x) {
                        nextCommand = block(index,self.commandArray.lastObject,x,nil,NO);
                        if (nextCommand) {
                            [self.commandArray addObject:nextCommand];
                            nextSignal = [nextCommand createSignal];
                        }
                    }] then:^RACSignal *{
                        return nextSignal;
                    }];
                }
            }
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        RACMulticastConnection *subjecConnect = [eachSignal publish];
        RACMulticastConnection *connection = [eachSignal multicast:subjecConnect.signal];
#pragma clang diagnostic pop
        @weakify(self, callback);
        RACCompoundDisposable *composable = [RACCompoundDisposable compoundDisposable];
        RACDisposable *subjectDisposable = [connection.signal  subscribeNext:^(id x) {
            @strongify(self, callback);
            [callback onNext:self AndData:x];
            SafeExecBlock(callbackBlock)(self, x, nil, NO);
            [(RACSubject *)[self valueForKey:@"addedExecutionSignalsSubject"] sendNext:x];
        } error:^(NSError *error) {
            @strongify(self, callback);
            [self setValue:@(NO) forKey:@"executing"];
            [callback onError:self AndError:error];
            SafeExecBlock(callbackBlock)(self, nil, error, NO);
            [(RACSubject *)[self valueForKey:@"addedExecutionSignalsSubject"] sendError:error];
        } completed:^{
            @strongify(self, callback);
            [self setValue:@(NO) forKey:@"executing"];
            [callback onComplete:self];
            SafeExecBlock(callbackBlock)(self, nil, nil, YES);
            [(RACSubject *)[self valueForKey:@"addedExecutionSignalsSubject"] sendCompleted];
        }];
        RACDisposable *connectDisposable = [connection connect];
        [composable addDisposable:connectDisposable];
        [composable addDisposable:subjectDisposable];
        @weakify(composable);
        self.cancelable = [[BlockCancelable alloc] initWithBlock:^{
            @strongify(composable, self);
            [self setValue:@(NO) forKey:@"executing"];
            [composable dispose];
        }];
        
        return self.cancelable;
    }else {
        return nil;
    }
}

- (NSMutableArray <__kindof kZMoonCommand *> *)commandArray {
    if (!_commandArray) {
        _commandArray = [NSMutableArray array];
    }
    return _commandArray;
}


@end
