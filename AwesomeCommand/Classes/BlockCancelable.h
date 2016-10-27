//
// Created by Senmiao on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "AwesomeCancelable.h"

typedef void(^AwesomeCancelBlock)(void);

@interface BlockCancelable : NSObject <AwesomeCancelable>

- (instancetype)initWithBlock:(AwesomeCancelBlock)block;

@end
