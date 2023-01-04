#import "FlutterPluginEngagelabPlugin.h"

#import "MTPushService.h"
#import <objc/runtime.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <UserNotifications/UserNotifications.h>
#define JPLog(fmt, ...) NSLog((@"| MTPushEngagelab | Flutter | iOS | " fmt), ##__VA_ARGS__)


@implementation NSDictionary (MTPush)
-(NSString*)toJsonString{
    NSError  *error;
    NSData   *data       = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end

@implementation NSString (MTPush)
-(NSDictionary*)toDictionary{
    NSError      *error;
    NSData       *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict     = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return dict;
}
@end

@interface FlutterPluginEngagelabPlugin ()<MTPushRegisterDelegate>

@end

@implementation FlutterPluginEngagelabPlugin

NSDictionary *_completeLaunchNotification;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_engagelab"
            binaryMessenger:[registrar messenger]];
  FlutterPluginEngagelabPlugin* instance = [[FlutterPluginEngagelabPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
    instance.channel = channel;
    
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
    NSString* name = call.method;
    NSArray * data =  call.arguments;
    
    if ([name isEqualToString:(@"init")]) {
        [self initSdk:data result:result];
      }else if ([name isEqualToString:(@"getRegistrationId")]){
          [self registrationIDCompletionHandler:data result:result];
      }else if ([name isEqualToString:(@"setNotificationBadge")]){
          [self setBadge:data];
      }else if ([name isEqualToString:(@"resetNotificationBadge")]){
          [self resetBadge];
      }else if ([name isEqualToString:(@"configDebugMode")]){
          [self setDebugMode:data];
      }else{
          
            result(FlutterMethodNotImplemented);
      }
}


-(void)initSdk:(NSArray*)data result:(FlutterResult)result{

    NSDictionary *launchOptions = _completeLaunchNotification;

    NSDictionary *arguments = [data objectAtIndex:0];

    NSString *appkey       = arguments[@"appKey"];
    NSString *channel      = arguments[@"channel"];
    NSNumber *isProduction = arguments[@"production"];
    NSNumber *isIDFA       = arguments[@"idfa"];

    __block NSString *advertisingId = nil;
    if(isIDFA.boolValue) {
          if (@available(iOS 14, *)) {
              //设置Info.plist中 NSUserTrackingUsageDescription 需要广告追踪权限，用来定位唯一用户标识
              [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                  if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                  }
              }];
          } else {
              // 使用原方式访问 IDFA
            advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
          }
    }
    [MTPushService setupWithOption:launchOptions
                           appKey:appkey
                          channel:channel
                 apsForProduction:[isProduction boolValue]
            advertisingIdentifier:advertisingId];
}


-(void)registrationIDCompletionHandler:(NSArray*)data result:(FlutterResult)result {
    [MTPushService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        if (resCode == 0) {
            result(registrationID);
        } else {
            result(@"");
        }
    }];

}

-(void)setBadge:(NSArray* )data {
    int value = [data objectAtIndex:0];
    [MTPushService setBadge:value];
}


-(void)resetBadge {
    [MTPushService resetBadge];
}


-(void)setDebugMode:(NSArray* )data {
    bool value = [data objectAtIndex:0];
    if (value) {
        [MTPushService setDebugMode];
    }
}






#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    JPLog(@"application:didFinishLaunchingWithOptions");
    _completeLaunchNotification = launchOptions;
    // 3.0.0及以后版本注册
        MTPushRegisterEntity * entity = [[MTPushRegisterEntity alloc] init];
        if (@available(iOS 12.0, *)) {
          entity.types = MTPushAuthorizationOptionAlert|MTPushAuthorizationOptionBadge|MTPushAuthorizationOptionSound|MTPushAuthorizationOptionProvidesAppNotificationSettings;
        } else {
          entity.types = MTPushAuthorizationOptionAlert|MTPushAuthorizationOptionBadge|MTPushAuthorizationOptionSound;
        }
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
          //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        }
        [MTPushService registerForRemoteNotificationConfig:entity delegate:self];
    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];


      // 检测通知授权情况。可选项，不一定要放在此处，可以运行一定时间后再调用
      [self performSelector:@selector(checkNotificationAuthorization) withObject:nil afterDelay:10];


  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self
    selector:@selector(networkDidReceiveMessage:)
        name:kMTCNetworkDidReceiveMessageNotification
      object:nil];

 [defaultCenter addObserver:self
                    selector:@selector(networkDidLogin:)
                        name:kMTCNetworkDidLoginNotification
                      object:nil];


    return YES;
}



//ok
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned int *tokenBytes = [deviceToken bytes];
       NSString *tokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                             ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                             ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                             ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
       JPLog(@"Device Token: %@", tokenString);
       [MTPushService registerDeviceToken:deviceToken];
}



//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//  [MTPushService handleRemoteNotification:userInfo];
//  NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//}
//
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    [MTPushService handleRemoteNotification:userInfo];
//    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
//    completionHandler(UIBackgroundFetchResultNewData);
//}



//ok
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;

      UNNotificationRequest *request = notification.request; // 收到推送的请求
      UNNotificationContent *content = request.content; // 收到推送的消息内容

      NSNumber *badge = content.badge;  // 推送消息的角标
      NSString *body = content.body;    // 推送消息体
      UNNotificationSound *sound = content.sound;  // 推送消息的声音
      NSString *subtitle = content.subtitle;  // 推送消息的副标题
      NSString *title = content.title;  // 推送消息的标题

      if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MTPushService handleRemoteNotification:userInfo];
        JPLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
      } else {
        // 判断为本地通知
        JPLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
      }
    [self callBackChannel:@"willPresentNotification" arguments:[[self jpushFormatAPNSDic:userInfo] toJsonString]];

      completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//ok
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
        UNNotificationRequest *request = response.notification.request; // 收到推送的请求
        UNNotificationContent *content = request.content; // 收到推送的消息内容

        NSNumber *badge = content.badge;  // 推送消息的角标
        NSString *body = content.body;    // 推送消息体
        UNNotificationSound *sound = content.sound;  // 推送消息的声音
        NSString *subtitle = content.subtitle;  // 推送消息的副标题
        NSString *title = content.title;  // 推送消息的标题

        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
          [MTPushService handleRemoteNotification:userInfo];
          NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        }
        else {
          // 判断为本地通知
          NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        }

    [self callBackChannel:@"didReceiveNotificationResponse" arguments:[[self jpushFormatAPNSDic:userInfo] toJsonString]];
    
        completionHandler();  // 系统要求执行这个方法
}


//客户端收到自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSString *title = [userInfo valueForKey:@"title"];
  NSString *content = [userInfo valueForKey:@"content"];
  NSDictionary *extra = [userInfo valueForKey:@"extras"];
  NSUInteger messageID = [[userInfo valueForKey:@"_j_msgid"] unsignedIntegerValue];

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

  [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

  NSString *currentContent = [NSString
      stringWithFormat:
          @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\nmessage:%ld\n",
          [NSDateFormatter localizedStringFromDate:[NSDate date]
                                         dateStyle:NSDateFormatterNoStyle
                                         timeStyle:NSDateFormatterMediumStyle],
                              title, content, [self logDic:extra],(unsigned long)messageID];
  NSLog(@"%@", currentContent);

    [self callBackChannel:@"networkDidReceiveMessage" arguments:[[self jpushFormatAPNSDic:userInfo] toJsonString]];

}

- (void)networkDidLogin:(NSNotification *)notification {
  NSLog(@"networkDidLogin 登录成功%@ \n", notification.userInfo.description);
    [self callBackChannel:@"networkDidLogin" arguments:@"true"];
}


#pragma mark - 通知权限引导

// 检测通知权限授权情况
- (void)checkNotificationAuthorization {
  [MTPushService requestNotificationAuthorization:^(MTPushAuthorizationStatus status) {
    // run in main thread, you can custom ui
    NSLog(@"notification authorization status:%lu", status);
    [self alertNotificationAuthorization:status];
  }];
}
// 通知未授权时提示，是否进入系统设置允许通知，仅供参考
- (void)alertNotificationAuthorization:(MTPushAuthorizationStatus)status {
  if (status < MTPushAuthorizationStatusAuthorized) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"允许通知" message:@"是否进入设置允许通知？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
  }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
  if (![dic count]) {
    return nil;
  }
  NSString *tempStr1 =
      [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                   withString:@"\\U"];
  NSString *tempStr2 =
      [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 =
      [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str =
      [NSPropertyListSerialization propertyListFromData:tempData
                                       mutabilityOption:NSPropertyListImmutable
                                                 format:NULL
                                       errorDescription:NULL];
  return str;
}

- (NSMutableDictionary *)jpushFormatAPNSDic:(NSDictionary *)dic {
  NSMutableDictionary *extras = @{}.mutableCopy;
  for (NSString *key in dic) {
    if([key isEqualToString:@"_j_business"]      ||
       [key isEqualToString:@"_j_msgid"]         ||
       [key isEqualToString:@"_j_uid"]           ||
       [key isEqualToString:@"actionIdentifier"] ||
       [key isEqualToString:@"aps"]) {
      continue;
    }
    extras[key] = dic[key];
  }
  NSMutableDictionary *formatDic = dic.mutableCopy;
  formatDic[@"extras"] = extras;
  return formatDic;
}


-(void)callBackChannel:(NSString*)eventName arguments:(NSString*)arguments{
    NSMutableDictionary *data = @{}.mutableCopy;
    data[@"event_name"] = eventName;
    data[@"event_data"] = arguments;

//    NSString *toC = [data toJsonString];
    JPLog(@"toC：%@",data);
    [_channel invokeMethod:@"onMTCommonReceiver" arguments:data];
}

@end
