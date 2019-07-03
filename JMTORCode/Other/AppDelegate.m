//
//  AppDelegate.m
//  JMORCode
//
//  Created by JM Zhao on 2017/11/21.
//  Copyright © 2017年 JunMing. All rights reserved.
//


#define kJPushAppKey @"3a76cf409786c3ba1851bfaf"
#define kJPushChannel @"Publishhh"

#import "AppDelegate.h"
#import "MORCodeController.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "JANALYTICSService.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //JPush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types =  JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types  =JPAuthorizationOptionAlert |JPAuthorizationOptionBadge |JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:  entity delegate:  self];
    
    [JPUSHService  setupWithOption: launchOptions appKey: kJPushAppKey
                          channel: kJPushChannel
                 apsForProduction:NO
            advertisingIdentifier:  nil];
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString * registrationID) {
        if (resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    JANALYTICSLaunchConfig*config =[[JANALYTICSLaunchConfig alloc] init];
    config.appKey= kJPushAppKey;
    config.channel =kJPushChannel;
    [JANALYTICSService setupWithConfig: config];
    
    _JMORCodeallowRotationJMORCode = NO;
    
    [self JMORCodesetroot];
    
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)JMORCodesetroot{
    
    MORCodeController *VC = [[MORCodeController alloc] init];
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = rootVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}



#pragma mark - Push Service

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken: deviceToken];
}

- (void)application:(UIApplication *) application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


- (void)application: (UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *) userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult)) completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application: (UIApplication *) application
didReceiveLocalNotification: (UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront: notification identifierKey: nil];
}


- (void) jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler: (void (^)(NSInteger))completionHandler {
    
    completionHandler( UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound |UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter :(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary *userInfo=   response.notification.request.content.userInfo;
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    
    completionHandler();
}


@end
