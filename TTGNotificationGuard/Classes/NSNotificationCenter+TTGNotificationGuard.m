//
//  NSNotificationCenter+TTGNotificationGuard.m
//  Pods
//
//  Created by tutuge on 16/7/17.
//
//

#import "NSNotificationCenter+TTGNotificationGuard.h"
#import <objc/runtime.h>
#import "NSObject+TTGDeallocTaskHelper.h"

static BOOL TTGNotificationGuardEnable = NO;
static char TTGNotificationGuardDeallocTaskIdentifierKey;

@implementation NSNotificationCenter (TTGNotificationGuard)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class _ttg_methodSwizzlingWithClass:[self class]
                                 originalSelector:@selector(addObserver:selector:name:object:)
                                 swizzledSelector:@selector(ttg_addObserver:selector:name:object:)];
        
        [self.class _ttg_methodSwizzlingWithClass:[self class]
                                 originalSelector:@selector(removeObserver:)
                                 swizzledSelector:@selector(ttg_removeObserver:)];
        
        [self.class _ttg_methodSwizzlingWithClass:[self class]
                                 originalSelector:@selector(addObserverForName:object:queue:usingBlock:)
                                 swizzledSelector:@selector(ttg_addObserverForName:object:queue:usingBlock:)];
    });
}

#pragma mark - Public methods

+ (void)ttg_setTTGNotificationGuardEnable:(BOOL)enable {
    TTGNotificationGuardEnable = enable;
}

+ (BOOL)ttg_getTTGNotificationGuardEnable {
    return TTGNotificationGuardEnable;
}

#pragma mark - Swizzling methods

- (void)ttg_addObserver:(id)observer selector:(SEL)sel name:(NSString *)notificationName object:(id)sender {
    [self ttg_addObserver:observer selector:sel name:notificationName object:sender];
    [self.class _ttg_setAutoRemoveTaskForObserver:observer];
}

- (id<NSObject>)ttg_addObserverForName:(NSString *)name
                                object:(id)obj
                                 queue:(NSOperationQueue *)queue
                            usingBlock:(void (^)(NSNotification *note))block {
    id observer = [self ttg_addObserverForName:name object:obj queue:queue usingBlock:block];
    [self.class _ttg_setAutoRemoveTaskForObserver:observer];
    return observer;
}

- (void)ttg_removeObserver:(id)observer {
    [self.class _ttg_removeAutoRemoveTaskForObserver:observer];
    [self ttg_removeObserver:observer];
}

#pragma mark - Private methods

+ (void)_ttg_setAutoRemoveTaskForObserver:(id)observer {
    if (!TTGNotificationGuardEnable) {
        return;
    }
    
    NSUInteger identifier = [self _ttg_getDeallocTaskIdentifierFromObserver:observer];
    if (identifier == TTGDeallocTaskIllegalIdentifier) {
        identifier = [observer ttg_addDeallocTask:^(__unsafe_unretained id object, NSUInteger identifier) {
            [[NSNotificationCenter defaultCenter] removeObserver:object];
        }];
        [self _ttg_setDeallocTaskIdentifierToObserver:observer identifier:identifier];
    }
}

+ (void)_ttg_removeAutoRemoveTaskForObserver:(id)observer {
    NSUInteger identifier = [self _ttg_getDeallocTaskIdentifierFromObserver:observer];
    if (identifier != TTGDeallocTaskIllegalIdentifier) {
        [observer ttg_removeDeallocTaskByIdentifier:identifier];
    }
}

+ (NSUInteger)_ttg_getDeallocTaskIdentifierFromObserver:(id)observer {
    NSNumber *identifierNumber = objc_getAssociatedObject(observer, &TTGNotificationGuardDeallocTaskIdentifierKey);
    if (identifierNumber && [identifierNumber isKindOfClass:[NSNumber class]] && identifierNumber.unsignedIntegerValue != TTGDeallocTaskIllegalIdentifier) {
        return identifierNumber.unsignedIntegerValue;
    } else {
        return TTGDeallocTaskIllegalIdentifier;
    }
}

+ (void)_ttg_setDeallocTaskIdentifierToObserver:(id)observer identifier:(NSUInteger)identifier {
    NSNumber *identifierNumber = [NSNumber numberWithUnsignedInteger:identifier];
    if (identifierNumber) {
        objc_setAssociatedObject(observer, &TTGNotificationGuardDeallocTaskIdentifierKey, identifierNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)_ttg_methodSwizzlingWithClass:(Class) class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    if (!class || !originalSelector || !swizzledSelector) {
        return;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
