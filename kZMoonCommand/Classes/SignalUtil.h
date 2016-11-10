//
// Created by BupterAmbition on 16/5/31.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class kZMoonCommand;

@interface SignalUtil : NSObject

+ (RACSignal *)createSignal:(kZMoonCommand *)command;

@end
