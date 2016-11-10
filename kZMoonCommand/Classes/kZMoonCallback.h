//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>

@class kZMoonCommand;

@protocol kZMoonCallback <NSObject>

@required
- (void)onNext:(kZMoonCommand *)command AndData:(id)data;
- (void)onComplete:(kZMoonCommand *)command;
- (void)onError:(kZMoonCommand *)command AndError:(NSError *)error;

@end
