//
//  TTGViewController.m
//  TTGNotificationGuard
//
//  Created by zekunyan on 07/17/2016.
//  Copyright (c) 2016 zekunyan. All rights reserved.
//

#import "TTGViewController.h"
#import "NSNotificationCenter+TTGNotificationGuard.h"

static NSString *const TTGNotificationGuardTestNotificationName = @"TTGNotificationGuardTestNotificationName";

@interface TTGInnerTestClass : NSObject
@end

@implementation TTGInnerTestClass

- (void)receiverNotification:(NSNotification *)notification {
    NSLog(@"TTGInnerTestClass %@ receive notification", self);
}

@end

@interface TTGViewController ()
@property (weak, nonatomic) IBOutlet UILabel *switchInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@end

@implementation TTGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9) {
        [self showInfo:@"!!! Demo only work below iOS 9 !!!"];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)timerCallback {
    [[NSNotificationCenter defaultCenter] postNotificationName:TTGNotificationGuardTestNotificationName object:nil];
}

- (IBAction)runDemo:(id)sender {
    @autoreleasepool {
        TTGInnerTestClass *object = [TTGInnerTestClass new];
        [self showInfo:@"--------------------------------"];
        [self showInfo:[NSString stringWithFormat:@"New Object: %@ to receive notification.", object]];
        
        if (![NSNotificationCenter ttg_getTTGNotificationGuardEnable] && [UIDevice currentDevice].systemVersion.floatValue < 9) {
            [self showInfo:@"!!!!!! App will crash in 3 seconds !!!!!!"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:object
                                                 selector:@selector(receiverNotification:)
                                                     name:TTGNotificationGuardTestNotificationName
                                                   object:nil];
        
        __block id blockObject = object;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showInfo:[NSString stringWithFormat:@"Set object %@ to nil and release it.", blockObject]];
            blockObject = nil;
        });
    }
}

- (IBAction)guardSwitch:(UISwitch *)sender {
    [NSNotificationCenter ttg_setTTGNotificationGuardEnable:sender.on];
    _switchInfoLabel.text = [NSString stringWithFormat:@"TTGNotificationGuard is %@", sender.on ? @"on" : @"off"];
}

- (void)showInfo:(NSString *)info {
    _infoTextView.text = [NSString stringWithFormat:@"%@\n%@", _infoTextView.text, info];
    [_infoTextView scrollRangeToVisible:NSMakeRange(_infoTextView.text.length - 1, 0)];
}
@end
