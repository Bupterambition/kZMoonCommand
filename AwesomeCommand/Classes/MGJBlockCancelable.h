//
// Created by Zephyrleaves on 16/5/31.
//

#import <Foundation/Foundation.h>
#import "MGJAwesomeCancelable.h"

typedef void(^MGJAwesomeCancelBlock)(void);

@interface MGJBlockCancelable : NSObject <MGJAwesomeCancelable>

- (instancetype)initWithBlock:(MGJAwesomeCancelBlock)block;

@end