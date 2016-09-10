//
//  MGJCompoundCancelable.m
//  Pods
//
//  Created by Derek Chen on 9/1/16.
//
//

#import "MGJCompoundCancelable.h"

@interface MGJCompoundCancelable ()

@property (atomic, assign, getter = isCanceled) BOOL canceled;
@property (nonatomic, strong) NSMutableArray *cancelables;

@end

@implementation MGJCompoundCancelable

@synthesize canceled = _canceled;

- (void)dealloc {
    self.cancelables = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        @synchronized (self) {
            self.cancelables = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)initWithBlock:(MGJAwesomeCancelBlock)block {
    MGJBlockCancelable *blockCancelable = [[MGJBlockCancelable alloc] initWithBlock:block];
    if (blockCancelable) {
        return [self initWithCancelables:[NSArray arrayWithObject:blockCancelable]];
    } else {
        return nil;
    }
}

- (instancetype)initWithCancelables:(NSArray *)otherCancelables {
    self = [self init];
    if (self) {
        if (otherCancelables) {
            @synchronized (self) {
                [self.cancelables addObjectsFromArray:otherCancelables];
            }
        }
    }
    return self;
}

- (void)addCancelable:(id<MGJAwesomeCancelable>)cancelable {
    if (!cancelable || cancelable == self || [cancelable isCanceled]) {
        return;
    }
    
    @synchronized (self) {
        [self.cancelables addObject:cancelable];
    }
    
    if (self.isCanceled) {
        [cancelable cancel];
    }
}

- (void)removeCancelable:(id<MGJAwesomeCancelable>)cancelable {
    if (!cancelable) {
        return;
    }
    
    @synchronized (self) {
        [self.cancelables removeObject:cancelable];
    }
}

- (void)cancel {
    if (!self.isCanceled) {
        @synchronized (self) {
            [self.cancelables enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj conformsToProtocol:@protocol(MGJAwesomeCancelable)]) {
                    id<MGJAwesomeCancelable> cancelable = obj;
                    [cancelable cancel];
                }
            }];
            
            self.canceled = YES;
        }
    }
}

@end
