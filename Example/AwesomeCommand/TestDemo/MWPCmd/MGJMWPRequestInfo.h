//
//  MGJMWPRequestInfo.h
//  AwesomeCommand
//
//  Created by Derek Chen on 8/25/16.
//  Copyright © 2016 wentong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWP-SDK-iOS/RemoteBuild.h>

@interface MGJMWPRequestInfo : NSObject

@property (nonatomic, assign, readonly) RemoteMethod method;
@property (nonatomic, strong, readonly) NSString *api;
@property (nonatomic, strong, readonly) NSString *version;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, assign, readonly) BOOL useSecurity;
@property (nonatomic, strong, readonly) NSString *bizNamespace;
@property(nonatomic, readonly) Class returnClass;

- (MGJMWPRequestInfo *(^)(RemoteMethod))setMethod;
- (MGJMWPRequestInfo *(^)(NSString *))setAPI;
- (MGJMWPRequestInfo *(^)(NSString *))setVersion;
- (MGJMWPRequestInfo *(^)(NSDictionary *))setParams;
- (MGJMWPRequestInfo *(^)(BOOL))setUseSecurity;
- (MGJMWPRequestInfo *(^)(NSString *))setBizNamespace;
- (MGJMWPRequestInfo *(^)(Class))setReturnClass;

@end
