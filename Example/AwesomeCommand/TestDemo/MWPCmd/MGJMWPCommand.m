//
//  MGJMWPCommand.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/19/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPCommand.h"
#import "MGJMWPRequestInfo.h"
#import "MGJMWPResult.h"
#import <MWP-SDK-iOS/MWPRemote.h>
#import <MGJMacros/MGJMacros.h>
#import <MGJ-Categories/NSObject+MGJKit.h>

#define MWP_INIT_KEY    @"adapter_mwp_remote"

@interface MGJMWPCommand ()

@property (nonatomic, strong) MGJMWPRequestInfo *reqInfo;
@property (nonatomic, strong) MGJMWPResult *result;

@end

@implementation MGJMWPCommand

@synthesize reqInfo = _reqInfo;
@synthesize result = _result;

- (void)dealloc {
    self.reqInfo = nil;
    self.result = nil;
}

- (instancetype)initWithMWPRequestInfo:(MGJMWPRequestInfo *)reqInfo {
    NSCParameterAssert(reqInfo != nil);
    if (MGJ_IS_EMPTY(reqInfo.api) || MGJ_IS_EMPTY(reqInfo.version) || reqInfo.returnClass == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.reqInfo = reqInfo;
        NSCAssert(self.reqInfo != nil, @"Fail to init self.reqInfo!");
    }
    return self;
}

- (instancetype)initWithMWPAPI:(NSString *)api version:(NSString *)ver andReturnClass:(__unsafe_unretained Class)returnClass {
    if (MGJ_IS_EMPTY(api) || MGJ_IS_EMPTY(ver) || returnClass == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.reqInfo = [[MGJMWPRequestInfo alloc] init].setMethod(R_METHOD_POST).setAPI(api).setVersion(ver).setReturnClass(returnClass);
        NSCAssert(self.reqInfo != nil, @"Fail to init self.reqInfo!");
    }
    return self;
}

- (void)setParams:(NSDictionary *)params {
    if (self.reqInfo) {
        self.reqInfo.setParams(params);
    }
}

- (id<MGJAwesomeCancelable>)executeWithParams:(NSDictionary *)params {
    return [self executeWithParams:params andBlock:^(id<MGJAwesomeExecutable> cmd, id returnObj, NSString *status, NSString *msg, NSError *error, BOOL isCompleted) {
        ;
    }];
}

- (id<MGJAwesomeCancelable>)executeWithParams:(NSDictionary *)params andBlock:(MGJMWPExcuteCallbaclBlock)callbackBlock {
    if (!callbackBlock) {
        return nil;
    }
    [self setParams:params];
    @weakify(self);
    return [self executeWithBlock:^(id<MGJAwesomeExecutable> cmd, id data, NSError *error, BOOL isCompleted) {
        @strongify(self);
        MGJMWPResult *tmpResult = [[MGJMWPResult alloc] init];
        tmpResult.setError(error).setIsCompleted(isCompleted);
        if (data == nil) {
            MGJSafeExecBlock(callbackBlock)(cmd, nil, nil, nil, error, isCompleted);
        } else if ([data conformsToProtocol:@protocol(RemoteResponse)]) {
            id<RemoteResponse> response = data;
            tmpResult.setStatus([[response playLoad] ret]).setMessage([[response playLoad] msg]);
            if (self.reqInfo.returnClass != nil && [[[response playLoad] data] isKindOfClass:self.reqInfo.returnClass]) {
                tmpResult.setReturnObj([[response playLoad] data]);
                MGJSafeExecBlock(callbackBlock)(cmd, [[response playLoad] data], [[response playLoad] ret], [[response playLoad] msg], error, isCompleted);
            } else if (self.reqInfo.returnClass == nil) {
#if DEBUG
                NSCAssert(0, @"Not allow!");
#endif
                tmpResult.setReturnObj([[response playLoad] data]);
                MGJSafeExecBlock(callbackBlock)(cmd, [[response playLoad] data], [[response playLoad] ret], [[response playLoad] msg], error, isCompleted);
            } else {
                MGJSafeExecBlock(callbackBlock)(cmd, nil, [[response playLoad] ret], [[response playLoad] msg], error, isCompleted);
            }
        } else {
            NSCAssert(0, @"Not allow!");
        }
        self.result = tmpResult;
        NSLog(@"%@", self.result);
    }];
}

- (id<MGJAwesomeCancelable>)run:(id<MGJAwesomeResult>)result {
    if (MGJ_IS_EMPTY(result)) {
        return nil;
    }
    
    void (^callBack)(id) = ^(id<RemoteResponse> response) {
        if ([response error]) {
            [result onError:[response error]];
        } else {
            [result onNext:response];
            [result onComplete];
        }
    };
    
    id<ICall> disposeOperation = [[MWPRemote defaultRemote] buildMethod:self.reqInfo.method api:self.reqInfo.api version:self.reqInfo.version params:self.reqInfo.params useSecurity:self.reqInfo.useSecurity onCallback:callBack bizNamespace:self.reqInfo.bizNamespace classType:self.reqInfo.returnClass];
    
    return [[MGJBlockCancelable alloc] initWithBlock:^{
        [disposeOperation cancel];
    }];
}


#pragma mark - Accessor

@end
