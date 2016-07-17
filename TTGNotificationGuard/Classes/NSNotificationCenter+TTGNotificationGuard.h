//
//  NSNotificationCenter+TTGNotificationGuard.h
//  Pods
//
//  Created by tutuge on 16/7/17.
//
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (TTGNotificationGuard)

+ (void)ttg_setTTGNotificationGuardEnable:(BOOL)enable;

+ (BOOL)ttg_getTTGNotificationGuardEnable;

@end
