//
//  FFNotificationTool.m
//  FFNotification
//
//  Created by 燚 on 2017/12/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNotificationTool.h"
#import <UIKit/UIKit.h>


#ifdef DEBUG
#define FFLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define FFLog(format, ...)
#endif

#define FFSYSTEM_VERSION ([UIDevice currentDevice].systemVersion.floatValue)
#define FFSYSTEM_VERSION_MORE_THAN_8_0      (FFSYSTEM_VERSION >= 8.0)
#define FFSYSTEM_VERSION_MORE_THAN_9_0      (FFSYSTEM_VERSION >= 9.0)
#define FFSYSTEM_VERSION_MORE_THAN_10_0     (FFSYSTEM_VERSION >= 10.0)
#define FFSYSTEM_VERSION_MORE_THAN_11_0     (FFSYSTEM_VERSION >= 11.0)
#define FFUSER_NOT_OPEN_NOTIFICATION        ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone)
#define FFSHARED_TOOL [FFNotificationTool sharedTool]


@interface FFNotificationTool ()

@property (nonatomic, assign) BOOL canNotification;

@end

static FFNotificationTool *notificationTool = nil;

@implementation FFNotificationTool

/** shared tool */
+ (FFNotificationTool *)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (notificationTool == nil) {
            notificationTool = [[FFNotificationTool alloc] init];
        }
    });
    return notificationTool;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wunguarded-availability"

#pragma mark - =============================== register notification ===============================
/** register notification */
+ (void)registerNotificationWithDelegate:(id)delegate Complete:(RegisterCompleteBlock)block {
    if (delegate == nil) {
        delegate = [UIApplication sharedApplication].delegate;
    }

    if (FFSYSTEM_VERSION_MORE_THAN_10_0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = delegate;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted && !error) {
                FFSHARED_TOOL.canNotification = YES;
                if (block) {
                    block(YES, error);
                }
            } else {
                FFSHARED_TOOL.canNotification = NO;
                if (block) {
                    block(NO, error);
                }
            }
        }];

        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            FFLog(@"settings === %@",settings);
        }];

    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }


    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (void)registerNotificationWithFFNotificationToolComplete:(RegisterCompleteBlock)block {
    [FFNotificationTool registerNotificationWithDelegate:[FFNotificationTool sharedTool] Complete:block];
}

+ (void)registerNotificationWithAppDelegateComplete:(RegisterCompleteBlock)block {
    [FFNotificationTool registerNotificationWithDelegate:[UIApplication sharedApplication].delegate Complete:block];
}


#pragma mark - =============================== add notification ===============================
+ (void)addNotificationAddNotificationBlock:(AddNotificationBlock)addNotificationBlock {
    if (FFSHARED_TOOL.canNotification == NO) {
        if (addNotificationBlock) {
            addNotificationBlock(NO, @"user closes the notification or No registration notification");
        }
        return;
    }

    if (FFSYSTEM_VERSION_MORE_THAN_10_0) {

        UNNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];


        UNMutableNotificationContent *content = [FFNotificationTool ContentWithTitle:@"haha" SubTitle:nil Body:@"今天天气不错" Badge:@2 Sound:nil UserInfo:@{@"2":@"1"}];

        NSString *requestIdentifier = @"test 1 1 1 1 1 ";

        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];

        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                addNotificationBlock(YES, @"add noticifation success");
            } else {
                addNotificationBlock(NO, error.localizedDescription);
            }
        }];


    } else {


    }

}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
+ (UNMutableNotificationContent *)ContentWithTitle:(NSString *)title SubTitle:(NSString *)subTtitle Body:(NSString *)body  Badge:(NSNumber *)badge Sound:(NSString *)sound UserInfo:(NSDictionary *)userInfo {

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.subtitle = subTtitle;
    content.body = body;
    content.badge = badge;
    if (sound.length > 1) {
        content.sound = [UNNotificationSound soundNamed:sound];
    } else {
        content.sound = [UNNotificationSound defaultSound];
    }
    content.userInfo = userInfo;

    return content;
}
#endif




+ (void)addNotificationWithTimeInterval:(NSTimeInterval)timeInterval Repeats:(BOOL)repeats Title:(NSString *)title SubTitle:(NSString *)subTtitle Body:(NSString *)body Sound:(NSString *)sound UserInfo:(NSDictionary *)userInfo {

}




















#pragma clang diagnostic pop
@end
