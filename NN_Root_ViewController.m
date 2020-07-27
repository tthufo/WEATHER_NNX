//
//  HT_Root_ViewController.m
//  HearThis
//
//  Created by Thanh Hai Tran on 10/4/16.
//  Copyright © 2016 Thanh Hai Tran. All rights reserved.
//

#import "NN_Root_ViewController.h"

#import "HT_Feed_ViewController.h"

#import "HT_More_ViewController.h"

#import "Second_Tab_ViewController.h"

#import "Third_Tab_ViewController.h"

#import "Nhà_Nông_Xanh-Swift.h"

@interface NN_Root_ViewController ()<UIGestureRecognizerDelegate>
{
    UIView * banner;
    
    BOOL isHidden;
}
@end

@implementation NN_Root_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabBar];
    
//    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
//                                                                                              action:@selector(handlePan:)];
//    [pan setEdges:UIRectEdgeLeft];
//    [pan setDelegate:self];
//    [self.view addGestureRecognizer:pan];
}

- (void)handlePan:(id)sender
{
    [[self ROOT] toggleLeftPanel:nil];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

- (void)initTabBar
{
    PC_Weather_Main_ViewController * weather = [PC_Weather_Main_ViewController new];
    
    UINavigationController *nav1 = [[UINavigationController alloc]
                                    initWithRootViewController:weather];
    
    nav1.navigationBarHidden = YES;
        
    nav1.tabBarItem.image = [[UIImage imageNamed:@"ic_tab_weather"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // [UIImage imageNamed:@"ic_tab_weather"];
    
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_tab_weather_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; //[UIImage imageNamed:@"ic_tab_weather_active"];
    
    
    
    NN_List_ViewController * weather1 = [NN_List_ViewController new];
         
    weather1.titleText = @"Video";

      weather1.cateId = @"795";
    
     UINavigationController *nav2 = [[UINavigationController alloc]
                                     initWithRootViewController:weather1];
     
     nav2.navigationBarHidden = YES;
         
     nav2.tabBarItem.image = [[UIImage imageNamed:@"ic_tab_attp"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     
     nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_tab_attp_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    NN_List_ViewController * weather2 = [NN_List_ViewController new];
      
    weather2.titleText = @"Tin nổi bật";

    weather2.cateId = @"6281";
    
//    weather2.titleText = @"Tin nổi bật";
    
      UINavigationController *nav3 = [[UINavigationController alloc]
                                      initWithRootViewController:weather2];
      
      nav3.navigationBarHidden = YES;
          
      nav3.tabBarItem.image = [[UIImage imageNamed:@"ic_tab_hot_news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
      nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_tab_hot_news_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     
    
    
    Third_Tab_ViewController * weather3 = [Third_Tab_ViewController new];
      
      UINavigationController *nav4 = [[UINavigationController alloc]
                                      initWithRootViewController:weather3];
      
      nav4.navigationBarHidden = YES;
          
      nav4.tabBarItem.image = [[UIImage imageNamed:@"ic_tab_nhanong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      
      nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_tab_nhanong_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     
//    First_Tab_ViewController * first = [First_Tab_ViewController new];
//    
//    UINavigationController *nav1 = [[UINavigationController alloc]
//                                    initWithRootViewController:first];
//    
//    nav1.navigationBarHidden = YES;
//    
//    first.title = @"Kho sách";
//    
//    nav1.tabBarItem.image = [UIImage imageNamed:@"ic_home_normal"];
//    
//    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_home_active"];
//
//    
//    Second_Tab_ViewController * second = [Second_Tab_ViewController new];
//    
//    second.title = @"Hiệu sách";
//    
//    UINavigationController *nav2 = [[UINavigationController alloc]
//                                    initWithRootViewController:second];
//    
//    nav2.navigationBarHidden = YES;
//
//    nav2.tabBarItem.image = [UIImage imageNamed:@"ic_hieusach_normal"];
//    
//    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_hieusach_active"];
//
//
//    Third_Tab_ViewController * third = [Third_Tab_ViewController new];
//    
//    third.title = @"Tủ sách";
//    
//    UINavigationController *nav3 = [[UINavigationController alloc]
//                                    initWithRootViewController:third];
//    
//    nav3.navigationBarHidden = YES;
//
//    nav3.tabBarItem.image = [UIImage imageNamed:@"ic_tusach_normal"];
//    
//    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_tusach_active"];
//
//
//    PC_Info_ViewController * fourth = [PC_Info_ViewController new];
//    
//    fourth.title = @"Tài khoản";
//    
//    UINavigationController *nav4 = [[UINavigationController alloc]
//                                    initWithRootViewController:fourth];
//    
//    nav4.navigationBarHidden = YES;
//
//    nav4.tabBarItem.image = [UIImage imageNamed:@"ic_account_normal"];
//    
//    nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_account_active"];

//    HT_More_ViewController * fifth = [HT_More_ViewController new];
//
//    fifth.title = @"Extras";
//
//    UINavigationController *nav5 = [[UINavigationController alloc]
//                                    initWithRootViewController:fifth];
//
//    nav5.tabBarItem.image = [UIImage imageNamed:@"extras"];
    
//    self.viewControllers = [Information.check isEqualToString:@"1"] ? @[nav1, nav2, nav3, nav4] : @[nav1, nav2, nav3];
    
    self.viewControllers = @[nav1, nav3, nav4, nav2];
    
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(16, 0, 0, 0);
//    self.title = nil;

    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
           vc.tabBarItem.title = nil;
           vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
       }];

//
//    for(UITabBarItem * button in self.tabBar.items)
//    {
//        [button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [UIFont fontWithName:@"Helvetica" size:8.5], NSFontAttributeName, nil]
//                              forState:UIControlStateNormal];
//    }
    
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth1, 1)];
//    line.backgroundColor = [UIColor redColor];
//    [self.tabBar addSubview: line];
}

- (void)reAdsAdd
{

}

- (void)didShowBanner
{
    if(![[LTRequest sharedInstance] isConnectionAvailable])
    {
        return;
    }
    
}

- (NSDictionary*)returnDictionary:(NSDictionary*)dict
{
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for(NSDictionary * key in dict[@"plist"][@"dict"][@"key"])
    {
        result[key[@"jacknode"]] = dict[@"plist"][@"dict"][@"string"][[dict[@"plist"][@"dict"][@"key"] indexOfObject:key]][@"jacknode"];
    }
    
    return result;
}

- (void)didRequestInfo
{
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"https://dl.dropboxusercontent.com/s/oc2v05ni2c1mvdo/HearItAgain.plist",@"overrideError":@(1)} withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSString* errorCode, NSError *error, BOOL isValidated, NSDictionary * object) {
        
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * er = nil;
        NSDictionary * dict = [self returnDictionary: [XMLReader dictionaryForXMLData:data
                                                                              options:XMLReaderOptionsProcessNamespaces
                                                                                error:&er]];
        if(dict.allKeys.count != 0)
        {
            [self addObject:@{@"banner":dict[@"banner"],@"fullBanner":dict[@"fullBanner"],@"adsMob":dict[@"ads"],@"itune":dict[@"itune"],@"alert":[dict responseForKey:@"alert"] ? dict[@"alert"] : @""} andKey:@"adsInfo"];
            
            if([dict responseForKey:@"alert"] && ((NSString*)dict[@"alert"]).length != 0)
            {
                if(![self getValue:dict[@"key"]])
                {
                    [self addValue:dict[@"alert"] andKey:dict[@"key"]];
                    
                    [[[EM_MenuView alloc] initWithSubMenu:@{@"message":dict[@"alert"]}] showWithCompletion:^(int index, id object, EM_MenuView *menu) {
                        
                        [menu close];
                                                
                    }];
                }
            }
            
            if([dict responseForKey:@"direct"] && ((NSString*)dict[@"direct"]).length != 0)
            {
                if(![self getValue:dict[@"directKey"]])
                {
                    [self addValue:dict[@"directKey"] andKey:dict[@"directKey"]];
                    
//                    [[[EM_MenuView alloc] initWithWebView:@{@"url":dict[@"direct"]}] show];
                }
            }
        }
        
        BOOL isUpdate = data ? [dict[@"version"] compare:[self appInfor][@"majorVersion"] options:NSNumericSearch] == NSOrderedDescending : NO;
        
        if(isUpdate)
        {
            [[DropAlert shareInstance] alertWithInfor:@{/*@"option":@(0),@"text":@"wwww",*/@"cancel":@"Close",@"buttons":@[@"Download now"],@"title":@"New Update",@"message":dict[@"update_message"]} andCompletion:^(int indexButton, id object) {
                switch (indexButton)
                {
                    case 0:
                    {
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dict[@"url"]]])
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"url"]]];
                        }
                    }
                        break;
                    case 1:
                        
                        break;
                    default:
                        break;
                }
            }];
        }
    }];
}

- (void)didResetLogout {
    self.selectedIndex = 0;
    
    UINavigationController * nav = (UINavigationController *)[self.viewControllers firstObject];
    
    [((PC_Weather_Main_ViewController*)[nav.viewControllers firstObject]).tableView setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
