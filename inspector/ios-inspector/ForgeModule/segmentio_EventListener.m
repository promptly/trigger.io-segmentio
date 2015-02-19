#import "segmentio_EventListener.h"

#import "Analytics.h"

@implementation segmentio_EventListener

+ (void) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary* config = [[ForgeApp sharedApp] configForPlugin:@"segmentio"];
    
    Boolean debug = false;
    if ([config objectForKey:@"debug"] != nil) {
        debug = [[config objectForKey:@"debug"] boolValue];
    }

    [SEGAnalytics debug:debug];
    
    NSString* writeKey = [config objectForKey:@"ios_writeKey"];
    [SEGAnalytics setupWithConfiguration:[SEGAnalyticsConfiguration configurationWithWriteKey:writeKey]];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType types =
            (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:types categories:nil];

        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType types =
            (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);

        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [ForgeLog i:@"Segment: registered for remote notifications"];
    [[SEGAnalytics sharedAnalytics] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *errMsg =
        [NSString stringWithFormat:@"Segment: could not register for remote notifications: %@",
                                  [error localizedDescription]];
    
    [ForgeLog e:errMsg];
}

/* iOS 8+ only   */

+ (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [ForgeLog i:@"Segment: registered for user notifications"];
    //register to receive notifications
    [application registerForRemoteNotifications];
}

@end
