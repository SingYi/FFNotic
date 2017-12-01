//
//  FFNotificationTool.h
//  FFNotification
//
//  Created by 燚 on 2017/12/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif


typedef void(^RegisterCompleteBlock)(BOOL success, NSError * _Nullable error);
typedef void(^AddNotificationBlock)(BOOL success, NSString * _Nullable resultString);



@interface FFNotificationTool : NSObject

#pragma mark - =============================== register notification ===============================
/** register notification */
+ (void)registerNotificationWithDelegate:(id _Nullable)delegate Complete:(RegisterCompleteBlock _Nullable )block;

+ (void)registerNotificationWithFFNotificationToolComplete:(RegisterCompleteBlock _Nullable )block;

+ (void)registerNotificationWithAppDelegateComplete:(RegisterCompleteBlock _Nullable )block;

#pragma mark - =============================== add notification ===============================
/** add notification */
+ (void)addNotificationAddNotificationBlock:(AddNotificationBlock _Nullable)addNotificationBlock;

+ (UNMutableNotificationContent *)ContentWithTitle:(NSString *)title SubTitle:(NSString *)subTtitle Body:(NSString *)body  Badge:(NSNumber *)badge Sound:(NSString *)sound UserInfo:(NSDictionary *)userInfo;




@end
