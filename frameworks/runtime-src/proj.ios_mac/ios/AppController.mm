/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "AppController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>

@implementation AppController

@synthesize window;

static AppController *s_self;

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    cocos2d::Application *app = cocos2d::Application::getInstance();
    
    // Initialize the GLView attributes
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

    // Use RootViewController to manage CCEAGLView
    _viewController = [[RootViewController alloc]init];
    _viewController.wantsFullScreenLayout = YES;
    

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: _viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:_viewController];
    }

    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden:true];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView((__bridge void *)_viewController.view);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    s_self = self;
    s_self.orientationMask = UIInterfaceOrientationLandscapeRight;
    [s_self.class changeRootViewControllerH];
    
    //run the cocos2d-x game scene
    app->run();

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->pause(); */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // We don't need to call this method any more. It will interrupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->resume(); */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

+(NSString*) getIosId {
     int                 mgmtInfoBase[6];
     char                *msgBuffer = NULL;
     size_t              length;
     unsigned char       macAddress[6];
     struct if_msghdr    *interfaceMsgStruct;
     struct sockaddr_dl  *socketStruct;
     NSString            *errorFlag = NULL;
     
     mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
     mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
     mgmtInfoBase[2] = 0;
     mgmtInfoBase[3] = AF_LINK;        // Request link layer information
     mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
     
     if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
         errorFlag = @"if_nametoindex failure";
     else
     {
         if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
             errorFlag = @"sysctl mgmtInfoBase failure";
         else
         {
             if ((msgBuffer = (char*)malloc(length)) == NULL)
                 errorFlag = @"buffer allocation failure";
             else
             {
                 if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                     errorFlag = @"sysctl msgBuffer failure";
             }
         }
     }
     
     if (errorFlag != NULL)
     {
         NSLog(@"Error: %@", errorFlag);
         const char*  error =[errorFlag UTF8String];
         return [NSString stringWithUTF8String:error];
     }
     interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
     socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
     memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
     NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                   macAddress[0], macAddress[1], macAddress[2],
                                   macAddress[3], macAddress[4], macAddress[5]];
     NSLog(@"Mac Address: %@", macAddressString);
     free(msgBuffer);
    
     const char*  address =[macAddressString UTF8String];
     return [NSString stringWithUTF8String:address];
 }

+ (NSString *) getAppPackageName {
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"AppController getAppPackageName:%@", bundle);
    return bundle;
}

+ (NSString *) getVersionName {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"AppController getVersionName:%@", version);
    return version;
}

+ (NSString *) getOrientation {
    NSLog(@"AppController getOrientation");
    return @"";
}

+ (void) changeOrientation:(NSDictionary*) dict {
    NSString* orientation = [dict objectForKey:@"orientation"];
    NSLog(@"AppController changeOrientation:%@", orientation);
    int ori = [orientation intValue];
    if(ori == 1)
    {
        NSLog(@"changeRootViewControllerH");
        [AppController changeRootViewControllerH];
    }
    else
    {
        NSLog(@"changeRootViewControllerV");
        [AppController changeRootViewControllerV];
    }
}

+ (void)changeRootViewControllerH {
//    NSLog(@"changeRootViewController Landscape");
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    
    s_self->_viewController.orientationMask = UIInterfaceOrientationMaskLandscape;
    s_self->_viewController.orientation = UIInterfaceOrientationLandscapeRight;
    s_self.orientationMask = UIInterfaceOrientationMaskLandscape;
    
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    
    if (@available(iOS 16.0, *)) {
        void (^errorHandler)(NSError *error) = ^(NSError *error) {
                NSLog(@"错误:%@", error);
            };
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL supportedInterfaceSelector = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            [s_self->_viewController performSelector:supportedInterfaceSelector];
            NSArray *array = [[UIApplication sharedApplication].connectedScenes allObjects];
            UIWindowScene *scene = (UIWindowScene *)[array firstObject];
            Class UIWindowSceneGeometryPreferencesIOS = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
            if (UIWindowSceneGeometryPreferencesIOS) {
                SEL initWithInterfaceOrientationsSelector = NSSelectorFromString(@"initWithInterfaceOrientations:");
                UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskLandscape;
                id geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] performSelector:initWithInterfaceOrientationsSelector withObject:@(orientation)];
                if (geometryPreferences) {
                    SEL requestGeometryUpdateWithPreferencesSelector = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
                    if ([scene respondsToSelector:requestGeometryUpdateWithPreferencesSelector]) {
                        [scene performSelector:requestGeometryUpdateWithPreferencesSelector withObject:geometryPreferences withObject:errorHandler];
                    }
                }
            }
        #pragma clang diagnostic pop
    } else {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        }
}

+ (void)changeRootViewControllerV {
//    NSLog(@"changeRootViewController Portrait");

    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    
    s_self->_viewController.orientationMask = UIInterfaceOrientationMaskPortrait;
    s_self->_viewController.orientation = UIInterfaceOrientationPortrait;
    s_self.orientationMask = UIInterfaceOrientationMaskAll;
    
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    if (@available(iOS 16.0, *)) {
        void (^errorHandler)(NSError *error) = ^(NSError *error) {
                NSLog(@"错误:%@", error);
            };
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL supportedInterfaceSelector = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            [s_self->_viewController performSelector:supportedInterfaceSelector];
            NSArray *array = [[UIApplication sharedApplication].connectedScenes allObjects];
            UIWindowScene *scene = (UIWindowScene *)[array firstObject];
            Class UIWindowSceneGeometryPreferencesIOS = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
            if (UIWindowSceneGeometryPreferencesIOS) {
                SEL initWithInterfaceOrientationsSelector = NSSelectorFromString(@"initWithInterfaceOrientations:");
                UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskPortrait;
                id geometryPreferences = [[UIWindowSceneGeometryPreferencesIOS alloc] performSelector:initWithInterfaceOrientationsSelector withObject:@(orientation)];
                if (geometryPreferences) {
                    SEL requestGeometryUpdateWithPreferencesSelector = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
                    if ([scene respondsToSelector:requestGeometryUpdateWithPreferencesSelector]) {
                        [scene performSelector:requestGeometryUpdateWithPreferencesSelector withObject:geometryPreferences withObject:errorHandler];
                    }
                }
            }
        #pragma clang diagnostic pop
        } else {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        }
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [window release];
    [_viewController release];
    [super dealloc];
}
#endif


@end
