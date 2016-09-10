//
//  MGJMWPRequestInfo.m
//  AwesomeCommand
//
//  Created by Derek Chen on 8/25/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import "MGJMWPRequestInfo.h"
#import <MGJMacros/MGJMacros.h>

@interface MGJMWPRequestInfo ()

@property (nonatomic, assign) RemoteMethod method;
@property (nonatomic, strong) NSString *api;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) BOOL useSecurity;
@property (nonatomic, strong) NSString *bizNamespace;
@property(nonatomic) Class returnClass;

@end

@implementation MGJMWPRequestInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

- (MGJMWPRequestInfo *(^)(RemoteMethod))setMethod {
    return ^MGJMWPRequestInfo *(RemoteMethod value) {
        if (value <= R_METHOD_POST) {
            self.method = value;
        }
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(NSString *))setAPI {
    return ^MGJMWPRequestInfo *(NSString *value) {
        if (!MGJ_IS_EMPTY(value)) {
            self.api = value;
        }
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(NSString *))setVersion {
    return ^MGJMWPRequestInfo *(NSString *value) {
        if (!MGJ_IS_EMPTY(value)) {
            self.version = value;
        }
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(NSDictionary *))setParams {
    return ^MGJMWPRequestInfo *(NSDictionary *value) {
        if (!MGJ_IS_EMPTY(value)) {
            self.params = value;
        }
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(BOOL))setUseSecurity {
    return ^MGJMWPRequestInfo *(BOOL value) {
        self.useSecurity = value;
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(NSString *))setBizNamespace {
    return ^MGJMWPRequestInfo *(NSString *value) {
        if (!MGJ_IS_EMPTY(value)) {
            self.bizNamespace = value;
        }
        return self;
    };
}

- (MGJMWPRequestInfo *(^)(Class))setReturnClass {
    return ^MGJMWPRequestInfo *(Class value) {
        self.returnClass = value;
        return self;
    };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@-%p:\n<Method>:%lu\n<API>:%@\n<Ver>:%@\n<UseSecurity>:%d\n<BizNamespace>:%@\n<ReturnClass>:%@\n<Params>:%@", [self class], self, (unsigned long)self.method, self.api, self.version, self.useSecurity, self.bizNamespace, self.returnClass, [self.params description]];
}

@end
