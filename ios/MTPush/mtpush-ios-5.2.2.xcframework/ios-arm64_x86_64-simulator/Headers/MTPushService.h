/*
 * Copyright (c) 2011 ~ 2017 Shenzhen MT. All rights reserved.
 */

#define MTP_VERSION_NUMBER 5.2.2

#import <Foundation/Foundation.h>

@class CLRegion;
@class UILocalNotification;
@class CLLocation;
@class UNNotificationCategory;
@class UNNotificationSettings;
@class UNNotificationRequest;
@class UNNotification;
@protocol MTPushRegisterDelegate;
@protocol MTPushInAppMessageDelegate;
@protocol MTPushNotiInMessageDelegate;

typedef void (^MTPushTagsOperationCompletion)(NSInteger iResCode, NSSet *iTags, NSInteger seq);
typedef void (^MTPushTagValidOperationCompletion)(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind);
typedef void (^MTPushAliasOperationCompletion)(NSInteger iResCode, NSString *iAlias, NSInteger seq);
typedef void (^MTPLiveActivityTokenCompletion)(NSInteger iResCode, NSString *iLiveActivityId, NSData *token, NSInteger seq);
typedef void (^MTPushVoipTokenCompletion)(NSInteger iResCode, NSString *msg);

extern NSString *const kMTCNetworkIsConnectingNotification; // 正在连接中
extern NSString *const kMTCNetworkDidSetupNotification;     // 建立连接
extern NSString *const kMTCNetworkDidCloseNotification;     // 关闭连接
extern NSString *const kMTCNetworkDidRegisterNotification;  // 注册成功
extern NSString *const kMTCNetworkFailedRegisterNotification; //注册失败
extern NSString *const kMTCNetworkDidLoginNotification;     // 登录成功
extern NSString *const kMTCNetworkDidReceiveMessageNotification;         // 收到消息(非APNS)
extern NSString *const kMTCServiceErrorNotification;  // 错误提示

typedef NS_OPTIONS(NSUInteger, MTPushAuthorizationOptions) {
    MTPushAuthorizationOptionNone    = 0,   // the application may not present any UI upon a notification being received
    MTPushAuthorizationOptionBadge   = (1 << 0),    // the application may badge its icon upon a notification being received
    MTPushAuthorizationOptionSound   = (1 << 1),    // the application may play a sound upon a notification being received
    MTPushAuthorizationOptionAlert   = (1 << 2),    // the application may display an alert upon a notification being received
    MTPushAuthorizationOptionCarPlay = (1 << 3),    // The ability to display notifications in a CarPlay environment.
    MTPushAuthorizationOptionCriticalAlert NS_AVAILABLE_IOS(12.0) = (1 << 4) ,   //The ability to play sounds for critical alerts.
    MTPushAuthorizationOptionProvidesAppNotificationSettings NS_AVAILABLE_IOS(12.0) = (1 << 5) ,      //An option indicating the system should display a button for in-app notification settings.
    MTPushAuthorizationOptionProvisional NS_AVAILABLE_IOS(12.0) = (1 << 6) ,     //The ability to post noninterrupting notifications provisionally to the Notification Center.
    MTPushAuthorizationOptionAnnouncement NS_AVAILABLE_IOS(13.0) = (1 << 7) , //The ability for Siri to automatically read out messages over AirPods.
};

typedef NS_ENUM(NSUInteger, MTPushAuthorizationStatus) {
    MTPushAuthorizationNotDetermined    = 0,   // The user has not yet made a choice regarding whether the application may post user notifications.
    MTPushAuthorizationStatusDenied,    // The application is not authorized to post user notifications.
    MTPushAuthorizationStatusAuthorized,    // The application is authorized to post user notifications.
    MTPushAuthorizationStatusProvisional NS_AVAILABLE_IOS(12.0),    // The application is authorized to post non-interruptive user notifications.
};

/*!
 * 通知注册实体类
 */
@interface MTPushRegisterEntity : NSObject

/*!
 * 支持的类型
 * badge,sound,alert
 */
@property (nonatomic, assign) NSInteger types;
/*!
 * 注入的类别
 * iOS10 UNNotificationCategory
 * iOS8-iOS9 UIUserNotificationCategory
 */
@property (nonatomic, strong) NSSet *categories;
@end

/*!
 * 进行删除、查找推送实体类
 */
@interface MTPushNotificationIdentifier : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSArray<NSString *> *identifiers; // 推送的标识数组
@property (nonatomic, copy) UILocalNotification *notificationObj NS_DEPRECATED_IOS(4_0, 10_0);  // iOS10以下可以传UILocalNotification对象数据，iOS10以上无效
@property (nonatomic, assign) BOOL delivered NS_AVAILABLE_IOS(10_0); // 在通知中心显示的或待推送的标志，默认为NO，YES表示在通知中心显示的，NO表示待推送的
@property (nonatomic, copy) void (^findCompletionHandler)(NSArray *results); // 用于查询回调，调用[findNotification:]方法前必须设置，results为返回相应对象数组，iOS10以下返回UILocalNotification对象数组；iOS10以上根据delivered传入值返回UNNotification或UNNotificationRequest对象数组（delivered传入YES，则返回UNNotification对象数组，否则返回UNNotificationRequest对象数组）

@end

/*!
 * 推送通知声音实体类
 * iOS10以上有效
 */
@interface MTPushNotificationSound : NSObject <NSCopying, NSCoding>
@property (nonatomic, copy) NSString *soundName; //普通通知铃声
@property (nonatomic, copy) NSString *criticalSoundName NS_AVAILABLE_IOS(12.0); //警告通知铃声
@property (nonatomic, assign) float criticalSoundVolume NS_AVAILABLE_IOS(12.0); //警告通知铃声音量，有效值在0~1之间，默认为1
@end


/*!
 * 推送内容实体类
 */
@interface MTPushNotificationContent : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *title;                // 推送标题
@property (nonatomic, copy) NSString *subtitle;             // 推送副标题
@property (nonatomic, copy) NSString *body;                 // 推送内容
@property (nonatomic, copy) NSNumber *badge;                // 角标的数字。如果不需要改变角标传@(-1)
@property (nonatomic, copy) NSString *action NS_DEPRECATED_IOS(8_0, 10_0); // 弹框的按钮显示的内容（IOS 8默认为"打开", 其他默认为"启动",iOS10以上无效）
@property (nonatomic, copy) NSString *categoryIdentifier;   // 行为分类标识
@property (nonatomic, copy) NSDictionary *userInfo;         // 本地推送时可以设置userInfo来增加附加信息，远程推送时设置的payload推送内容作为此userInfo
@property (nonatomic, copy) NSString *sound;                // 声音名称，不设置则为默认声音
@property (nonatomic, copy) MTPushNotificationSound *soundSetting NS_AVAILABLE_IOS(10.0);   //推送声音实体
@property (nonatomic, copy) NSArray *attachments NS_AVAILABLE_IOS(10_0);                 // 附件，iOS10以上有效，需要传入UNNotificationAttachment对象数组类型
@property (nonatomic, copy) NSString *threadIdentifier NS_AVAILABLE_IOS(10_0); // 线程或与推送请求相关对话的标识，iOS10以上有效，可用来对推送进行分组
@property (nonatomic, copy) NSString *launchImageName NS_AVAILABLE_IOS(10_0);  // 启动图片名，iOS10以上有效，从推送启动时将会用到
@property (nonatomic, copy) NSString *summaryArgument NS_AVAILABLE_IOS(12.0);  //插入到通知摘要中的部分参数。iOS12以上有效。
@property (nonatomic, assign) NSUInteger summaryArgumentCount NS_AVAILABLE_IOS(12.0); //插入到通知摘要中的项目数。iOS12以上有效。
@property (nonatomic, copy) NSString *targetContentIdentifier NS_AVAILABLE_IOS(13.0);  // An identifier for the content of the notification used by the system to customize the scene to be activated when tapping on a notification.
//iOS15以上的新增属性 interruptionLevel为枚举UNNotificationInterruptionLevel
// The interruption level determines the degree of interruption associated with the notification
@property (nonatomic, assign) NSUInteger interruptionLevel NS_AVAILABLE_IOS(15.0);
// Relevance score determines the sorting for the notification across app notifications. The expected range is between 0.0f and 1.0f.
@property (nonatomic, assign) double relevanceScore NS_AVAILABLE_IOS(15.0);
@end


/*!
 * 推送触发方式实体类
 * 注：dateComponents、timeInterval、region在iOS10以上可选择其中一个参数传入有效值，如果同时传入值会根据优先级I、II、III使其中一种触发方式生效，fireDate为iOS10以下根据时间触发时须传入的参数
 */
@interface MTPushNotificationTrigger : NSObject<NSCopying, NSCoding>

@property (nonatomic, assign) BOOL repeat;                  // 设置是否重复，默认为NO
@property (nonatomic, copy) NSDate *fireDate NS_DEPRECATED_IOS(2_0, 10_0);           // 用来设置触发推送的时间，iOS10以上无效
@property (nonatomic, copy) CLRegion *region NS_AVAILABLE_IOS(8_0);                  // 用来设置触发推送的位置，iOS8以上有效，iOS10以上优先级为I，应用需要有允许使用定位的授权
@property (nonatomic, copy) NSDateComponents *dateComponents NS_AVAILABLE_IOS(10_0); // 用来设置触发推送的日期时间，iOS10以上有效，优先级为II
@property (nonatomic, assign) NSTimeInterval timeInterval NS_AVAILABLE_IOS(10_0);    // 用来设置触发推送的时间，iOS10以上有效，优先级为III

@end

/*!
 * 注册或更新推送实体类
 */
@interface MTPushNotificationRequest : NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *requestIdentifier;    // 推送请求标识
@property (nonatomic, copy) MTPushNotificationContent *content; // 设置推送的具体内容
@property (nonatomic, copy) MTPushNotificationTrigger *trigger; // 设置推送的触发方式
@property (nonatomic, copy) void (^completionHandler)(id result); // 注册或更新推送成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil;iOS10以下成功result为UILocalNotification对象，失败则result为nil

@end

/*!
 * 应用内消息内容实体
 */
@interface MTPushInAppMessage : NSObject

@property (nonatomic, copy)   NSString *mesageId;    // 消息id
@property (nonatomic, copy)   NSString *title;       // 标题
@property (nonatomic, copy)   NSString *content;     // 内容
@property (nonatomic, strong) NSArray  *target;      // 目标页面
@property (nonatomic, copy)   NSString *clickAction; // 跳转地址
@property (nonatomic, strong) NSDictionary *extras;  // 附加字段

@end

/*!
 * MTPush 核心头文件
 */
@interface MTPushService : NSObject

///----------------------------------------------------
/// @name Setup 启动相关
///----------------------------------------------------

/*!
 * @abstract 启动SDK
 *
 * @param launchingOption 启动参数.
 * @param appKey 一个MTPush 应用必须的,唯一的标识. 请参考 MTPush 相关说明文档来获取这个标识.
 * @param channel 发布渠道. 可选.
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 *                     App 证书环境取决于profile provision的配置，此处建议与证书环境保持一致.
 *
 * @discussion 提供SDK启动必须的参数, 来启动 SDK.
 * 此接口必须在 App 启动时调用, 否则 MTPush SDK 将无法正常工作.
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction;

/*!
 * @abstract 启动SDK
 *
 * @param launchingOption 启动参数.
 * @param appKey 一个MTPush 应用必须的,唯一的标识. 请参考 MTPush 相关说明文档来获取这个标识.
 * @param channel 发布渠道. 可选.
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 *                     App 证书环境取决于profile provision的配置，此处建议与证书环境保持一致.
 * @param advertisingId 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
 *
 * @discussion 提供SDK启动必须的参数, 来启动 SDK.
 * 此接口必须在 App 启动时调用, 否则 MTPush SDK 将无法正常工作.
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;


/*!
 * @abstract 设置是否TCP加密连接
 * @param isSSL 加密传YES, 不加密传NO
 * @discussion 此接口必须要在SDK启动前进行设置
 */
+ (void)setTcpSSL:(BOOL)isSSL;

/*!
 * @abstract 允许SDK是否使用UDP，默认是允许
 * @param enableUdp 允许使用UDP传YES, 不允许使用UDP传NO
 * @discussion 此接口必须要在SDK启动前进行设置
 */
+ (void)setEnableUdp:(BOOL)enableUdp;

///----------------------------------------------------
/// @name APNs about 通知相关
///----------------------------------------------------

/*!
 * @abstract 注册要处理的远程通知类型
 *
 * @param types 通知类型
 * @param categories 类别组
 *
 */
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories;
/*!
 * @abstract 新版本的注册方法（兼容iOS10）
 *
 * @param config 注册通知配置
 * @param delegate 代理
 *
 */
+ (void)registerForRemoteNotificationConfig:(MTPushRegisterEntity *)config delegate:(id<MTPushRegisterDelegate>)delegate;

/*!
 * @abstract  向EngagaLab服务器提交Device Token
 *
 * @param deviceToken 推送使用的Device Token
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/*!
 * @abstract 上报liveactivity的启动token
 *
 * @param activityAttributes 某liveActivity定义的属性类型
 * @param pushToStartToken 对应该liveactivity的pushToStartToken，如有更新，请及时调用该方法更新pushToStartToken
 * @param completion 响应回调
 * @param seq  请求序列号
 */
+ (void)registerLiveActivity:(NSString *)activityAttributes
            pushToStartToken:(NSData *)pushToStartToken
                  completion:(MTPLiveActivityTokenCompletion)completion
                        seq:(NSInteger)seq;

/*!
 * @abstract 注册liveactivity并上报其pushtoken
 * 在pushtoken有变化的时候同步调用该接口。
 * 在liveactivity结束的时候，请同步调用该接口，pushtoken传nil
 *
 * @param liveActivityId 业务id,需要您自定义，可以关联多个liveActivity的pushtoken
 * @param pushToken liveactivity更新时使用的pushToken，如有更新，请及时调用该方法更新pushToken
 * @param completion 响应回调
 * @param seq  请求序列号
 */
+ (void)registerLiveActivity:(NSString *)liveActivityId
                   pushToken:(NSData *)pushToken
                  completion:(MTPLiveActivityTokenCompletion)completion
                         seq:(NSInteger)seq;

/*!
 * @abstract 处理收到的 APNs 消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

/*!
 * @abstract  向EngagaLab服务器提交Voip Token
 *
 * @param voipToken 推送使用的Voip Token
 */
+ (void)registerVoipToken:(NSData *)voipToken;

/*!
 * @abstract  向EngagaLab清除Voip Token
 *
 * @param completion 结果回调。 iResCode = 0 成功
 */
+ (void)unregisterVoipToken:(MTPushVoipTokenCompletion)completion;

/*!
 * @abstract  处理收到的 Voip 消息
 *
 * @param remoteInfo 下发的 Voip 内容
 */
+ (void)handleVoipNotification:(NSDictionary *)remoteInfo;



/*!
* @abstract 检测通知授权状态
* @param completion 授权结果通过status值返回，详见MTCAuthorizationStatus
*/
+ (void)requestNotificationAuthorization:(void (^)(MTPushAuthorizationStatus status))completion;

/*!
* @abstract 跳转至系统设置页面，iOS8及以上有效
*/
+ (void)openSettingsForNotification:(void (^)(BOOL success))completionHandler NS_AVAILABLE_IOS(8_0);

/*!
 * Tags操作接口
 * 支持增加/覆盖/删除/清空/查询操作
 */

/**
 增加tags

 @param tags 需要增加的tags集合
 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)addTags:(NSSet<NSString *> *)tags
     completion:(MTPushTagsOperationCompletion)completion
            seq:(NSInteger)seq;

/**
 覆盖tags
 调用该接口会覆盖用户所有的tags

 @param tags 需要设置的tags集合
 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)setTags:(NSSet<NSString *> *)tags
     completion:(MTPushTagsOperationCompletion)completion
            seq:(NSInteger)seq;

/**
 删除指定tags

 @param tags 需要删除的tags集合
 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)deleteTags:(NSSet<NSString *> *)tags
        completion:(MTPushTagsOperationCompletion)completion
               seq:(NSInteger)seq;

/**
 清空所有tags
 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)cleanTags:(MTPushTagsOperationCompletion)completion
              seq:(NSInteger)seq;

/**
 查询全部tags

 @param completion 响应回调，请在回调中获取查询结果
 @param seq 请求序列号
 */
+ (void)getAllTags:(MTPushTagsOperationCompletion)completion
               seq:(NSInteger)seq;

/**
 验证tag是否绑定
 
 @param completion 响应回调，回调中查看是否绑定
 @param seq 请求序列号
 */
+ (void)validTag:(NSString *)tag
      completion:(MTPushTagValidOperationCompletion)completion
             seq:(NSInteger)seq;

/**
 设置Alias

 @param alias 需要设置的alias
 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)setAlias:(NSString *)alias
      completion:(MTPushAliasOperationCompletion)completion
             seq:(NSInteger)seq;

/**
 删除alias

 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)deleteAlias:(MTPushAliasOperationCompletion)completion
                seq:(NSInteger)seq;

/**
 查询当前alias

 @param completion 响应回调
 @param seq 请求序列号
 */
+ (void)getAlias:(MTPushAliasOperationCompletion)completion
             seq:(NSInteger)seq;


/*!
 * @abstract 过滤掉无效的 tags
 *
 * @discussion 如果 tags 数量超过限制数量, 则返回靠前的有效的 tags.
 * 建议设置 tags 前用此接口校验. SDK 内部也会基于此接口来做过滤.
 */
+ (NSSet *)filterValidTags:(NSSet *)tags;


/*!
 * 应用内消息接口
 * 使用应用内消息需要配置以下两个接口。请在进入页面和离开页面的时候相应地配置。以下两个接口请配套调用。
 */

/**
 进入页面
 
 请与 + (void)pageLeave:(NSString *)pageName; 方法配套使用
 
 @param pageName 页面名
 @discussion 使用应用内消息功能，需要配置pageEnterTo:和pageLeave:函数。
 */
+ (void)pageEnterTo:(NSString *)pageName;


/**
 离开页面
 
 请与 + (void)pageEnterTo:(NSString *)pageName;方法配套使用
 
 @param pageName 页面名
 @discussion 使用应用内消息功能，需要配置pageEnterTo:和pageLeave:函数。
 */
+ (void)pageLeave:(NSString *)pageName;


/*!
* @abstract 设置应用内消息的代理
*
* @discussion 遵守MTPushInAppMessageDelegate的代理对象
*
*/
+ (void)setInAppMessageDelegate:(id<MTPushInAppMessageDelegate>)inAppMessageDelegate;


/*!
* @abstract 设置应用内提醒消息的代理
*
* @discussion 遵守JPushNotiInMessageDelegate的代理对象
*
*/
+ (void)setNotiInMessageDelegate:(id<MTPushNotiInMessageDelegate>)notiInMessageDelegate;



///----------------------------------------------------
/// @name Local Notification 本地通知
///----------------------------------------------------
/*!
 * @abstract 注册或更新推送 (支持iOS10，并兼容iOS10以下版本)
 *
 * @param request MTPushNotificationRequest类型，设置推送的属性，设置已有推送的request.requestIdentifier即更新已有的推送，否则为注册新推送，更新推送仅仅在iOS10以上有效，结果通过request.completionHandler返回
 * @discussion 旧的注册本地推送接口被废弃，使用此接口可以替换
 *
 */
+ (void)addNotification:(MTPushNotificationRequest *)request;

/*!
 * @abstract 移除推送 (支持iOS10，并兼容iOS10以下版本)
 *
 * @param identifier MTPushNotificationIdentifier类型，iOS10以上identifier设置为nil，则移除所有在通知中心显示推送和待推送请求，也可以通过设置identifier.delivered和identifier.identifiers来移除相应在通知中心显示推送或待推送请求，identifier.identifiers如果设置为nil或空数组则移除相应标志下所有在通知中心显示推送或待推送请求；iOS10以下identifier设置为nil，则移除所有推送，identifier.delivered属性无效，另外可以通过identifier.notificationObj传入特定推送对象来移除此推送。
 * @discussion 旧的所有删除推送接口被废弃，使用此接口可以替换
 *
 */
+ (void)removeNotification:(MTPushNotificationIdentifier *)identifier;

/*!
 * @abstract 查找推送 (支持iOS10，并兼容iOS10以下版本)
 *
 * @param identifier MTPushNotificationIdentifier类型，iOS10以上可以通过设置identifier.delivered和identifier.identifiers来查找相应在通知中心显示推送或待推送请求，identifier.identifiers如果设置为nil或空数组则返回相应标志下所有在通知中心显示推送或待推送请求；iOS10以下identifier.delivered属性无效，identifier.identifiers如果设置nil或空数组则返回所有未触发的推送。须要设置identifier.findCompletionHandler回调才能得到查找结果，通过(NSArray *results)返回相应对象数组。
 * @discussion 旧的查找推送接口被废弃，使用此接口可以替换
 *
 */
+ (void)findNotification:(MTPushNotificationIdentifier *)identifier;



///----------------------------------------------------
/// @name Server badge 服务器端 badge 功能
///----------------------------------------------------

/*!
 * @abstract 设置角标(到服务器)
 *
 * @param value 新的值. 会覆盖服务器上保存的值(这个用户)
 *
 * @discussion 本接口不会改变应用本地的角标值.
 * 本地仍须调用 UIApplication:setApplicationIconBadgeNumber 函数来设置脚标.
 *
 * 本接口用于配合 MTPush 提供的服务器端角标功能.
 * 该功能解决的问题是, 服务器端推送 APNs 时, 并不知道客户端原来已经存在的角标是多少, 指定一个固定的数字不太合理.
 *
 * MTPush 服务器端脚标功能提供:
 *
 * - 通过本 API 把当前客户端(当前这个用户的) 的实际 badge 设置到服务器端保存起来;
 * - 调用服务器端 API 发 APNs 时(通常这个调用是批量针对大量用户),
 *   使用 "+1" 的语义, 来表达需要基于目标用户实际的 badge 值(保存的) +1 来下发通知时带上新的 badge 值;
 */
+ (BOOL)setBadge:(NSInteger)value;

/*!
 * @abstract 重置脚标(为0)
 *
 * @discussion 相当于 [setBadge:0] 的效果.
 * 参考 [MTPushService setBadge:] 说明来理解其作用.
 */
+ (void)resetBadge;


/*!
 * @abstract 设置角标(到服务器)
 *
 * @param value 新的值. 会覆盖服务器上保存的值(这个用户)
 *
 * @param completion 响应回调。成功则error为空，失败则error带有错误码及错误信息
 *
 * @discussion 功能参考 [MTPushService setBadge:] 说明.
 *
 */
+ (void)setBadge:(NSInteger)value completion:(void (^)(NSError *error))completion;

///----------------------------------------------------
/// @name Other Feature 其他功能
///----------------------------------------------------

/*!
 * @abstract 设置手机号码(到服务器)
 *
 * @param mobileNumber 手机号码. 会与用户信息一一对应。可为空，为空则清除号码
 * @param completion 响应回调。成功则error为空，失败则error带有错误码及错误信息
 *
 * @discussion 设置手机号码后，可实现“推送不到短信到”的通知方式，提高推送达到率。结果信息通过completion异步返回，也可将completion设置为nil不处理结果信息。
 *
 */
+ (void)setMobileNumber:(NSString *)mobileNumber completion:(void (^)(NSError *error))completion;

///----------------------------------------------------
/// @name Logs and others 日志与其他
///----------------------------------------------------

/*!
 * @abstract MTPush标识此设备的 registrationID
 *
 * @discussion SDK注册成功后, 调用此接口获取到 registrationID 才能够获取到.
 *
 * MTPush 支持根据 registrationID 来进行推送.
 * 如果你需要此功能, 应该通过此接口获取到 registrationID 后, 上报到你自己的服务器端, 并保存下来.
 * registrationIDCompletionHandler:是新增的获取registrationID的方法，需要在block中获取registrationID,resCode为返回码,模拟器调用此接口resCode返回1011,registrationID返回nil.
 * 更多的理解请参考 MTPush 的文档.
 */
+ (NSString *)registrationID;

+ (void)registrationIDCompletionHandler:(void(^)(int resCode,NSString *registrationID))completionHandler;

/*!
 * @abstract 打开日志级别到 Debug
 *
 * @discussion JMessage iOS 的日志系统参考 Android 设计了级别.
 * 从低到高是: Verbose, Debug, Info, Warning, Error.
 * 对日志级别的进一步理解, 请参考 Android 相关的说明.
 *
 * SDK 默认开启的日志级别为: Info. 只显示必要的信息, 不打印调试日志.
 *
 * 请在SDK启动后调用本接口，调用本接口可打开日志级别为: Debug, 打印调试日志.
 */
+ (void)setDebugMode;

/*!
 * @abstract 关闭日志
 *
 * @discussion 关于日志级别的说明, 参考 [MTPushService setDebugMode]
 *
 * 虽说是关闭日志, 但还是会打印 Warning, Error 日志. 这二种日志级别, 在程序运行正常时, 不应有打印输出.
 *
 * 建议在发布的版本里, 调用此接口, 关闭掉日志打印.
 */
+ (void)setLogOFF;

/**
 * 设置设备语言（最好在注册成功之后再上报）
 * @param language 语言类型
 * @param handler  上报结果回调
 * 建议在登录成功之后再上报
 */
+ (void)setUserLanguage:(NSString *)language completionHandler:(void(^)(int resCode, NSError *error))handler;


/**
 * 设置 App Groups Id
 * @param appGroupId App Groups Id
 * 如有使用语音播报功能，请设置该值
 */
+ (void)setAppGroupId:(NSString *)appGroupId;

/**
 * 是否开启语音播报功能
 * @param enable 是否开启语音播报功能 YES:打开，NO:关闭，默认为NO
 */
+ (void)enablePushTextToSpeech:(BOOL)enable;

/**
 * 是否开启设备变更重置rid的功能 (在初始化函数setupWithOption:...方法之前调用)
 * @param enable 是否开启设备变更重置rid的功能 YES:打开，NO:关闭，默认为NO

 */
+ (void)enableResetOnDeviceChange:(BOOL)enable;


+ (void)setLCOn:(BOOL)enable;

+ (void)setLCCapacity:(NSInteger)capacity;


/*!
 * @abstract 设置数据中心
 *
 * @param siteName 数据中心的名称.
 *
 * @discussion 不设置的话使用默认的数据中心。此接口必须在 初始化函数之前 调用.
 */
+ (void)setSiteName:(NSString *)siteName __attribute__((deprecated("MTPush 4.3.5 版本已过期")));


@end

@class UNUserNotificationCenter;
@class UNNotificationResponse;

@protocol MTPushRegisterDelegate <NSObject>

/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler;
/*
 * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param response 通知响应对象
 * @param completionHandler
 */
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler;

/*
 * @brief handle UserNotifications.framework [openSettingsForNotification:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 当前管理的通知对象
 */
- (void)mtpNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification NS_AVAILABLE_IOS(12.0);

/*
 * 监测通知授权状态返回的结果
 * @param status 授权通知状态，详见MTCAuthorizationStatus
 * @param info 更多信息，预留参数
 */
- (void)mtpNotificationAuthorization:(MTPushAuthorizationStatus)status withInfo:(NSDictionary *)info;

@end


@protocol MTPushNotiInMessageDelegate <NSObject>

/**
 应用内提醒消息展示的回调
 
 @param content 应用内提醒消息的内容

 */
- (void)mtPushNotiInMessageDidShowWithContent:(NSDictionary *)content;

/**
 应用内提醒消息点击的回调
 
 @param content 应用内提醒消息的内容

 */
- (void)mtPushNotiInMessageDidClickWithContent:(NSDictionary *)content;

@end

@protocol MTPushInAppMessageDelegate <NSObject>

/**
 应用内消息展示的回调
 
 @param inAppMessage 应用内消息的内容

 */
- (void)mtPushInAppMessageDidShow:(MTPushInAppMessage *)inAppMessage;

/**
 应用内消息点击的回调
 
 @param inAppMessage 应用内消息的内容

 */
- (void)mtPushInAppMessageDidClick:(MTPushInAppMessage *)inAppMessage;

@end
