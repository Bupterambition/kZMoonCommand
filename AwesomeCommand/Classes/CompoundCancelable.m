//
//  CompoundCancelable.m
//  Pods
//
//  Created by    on 9/1/16.
//
//

#import "CompoundCancelable.h"

@interface CompoundCancelable ()

@property (atomic, assign, getter = isCanceled) BOOL canceled;
@property (nonatomic, strong) NSMutableArray *cancelables;

@end

@implementation CompoundCancelable

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

- (instancetype)initWithBlock:(AwesomeCancelBlock)block {
    BlockCancelable *blockCancelable = [[BlockCancelable alloc] initWithBlock:block];
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

- (void)addCancelable:(id<AwesomeCancelable>)cancelable {
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

- (void)removeCancelable:(id<AwesomeCancelable>)cancelable {
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
                if ([obj conformsToProtocol:@protocol(AwesomeCancelable)]) {
                    id<AwesomeCancelable> cancelable = obj;
                    [cancelable cancel];
                }
            }];
            
            self.canceled = YES;
        }
    }
}

@end
