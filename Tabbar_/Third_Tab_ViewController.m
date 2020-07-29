//
//  AP_Web_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/12/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "Third_Tab_ViewController.h"

#import "SC_Menu_ViewController.h"

#import "NNX-Swift.h"

@interface Third_Tab_ViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    IBOutlet NSLayoutConstraint * topBar;
    
    NSArray *tabsName;
    
    NSMutableArray * controllers;
    
    IBOutlet UILabel * titleLabel;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation Third_Tab_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
        
    self.topHeight = IS_IPAD ? @"84" : [self isIphoneX] ? @"108" : newOrientation == UIInterfaceOrientationPortrait ? @"84" : @"84";
    
    
    self.dataSource = self;
    
    self.delegate = self;
    
    tabsName = @[@"NHÀ NÔNG LÀM GIÀU", @"CHUYÊN GIA TƯ VẤN", @"CÔNG NGHỆ & MÔI TRƯỜNG", @"THỊ TRƯỜNG", @"NÔNG NGHIỆP SẠCH", @"AN TOÀN THỰC PHẨM"];
    
    NSMutableArray * arr = [NSMutableArray new];
    
    NSArray * cats = @[
    @"762",
    @"6296",
    @"6297",
    @"574",
    @"40506",
    @"6274"];
    
    NSMutableArray * cons = [NSMutableArray new];
    
    for(int i = 0; i < tabsName.count; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"%f", (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) ? [[self modelLabel:i] sizeOfLabel].width + 5 : [[self modelLabel:i] sizeOfLabel].width + 5]];
        
        NN_List_ViewController * weather1 = [NN_List_ViewController new];
                
        weather1.isHidden = YES;

        weather1.cateId = cats[i];
        
        [cons addObject:weather1];
    }
        
    //if((IS_IPHONE_5 || IS_IPHONE_4_OR_LESS))
    {
        self.arr = arr;
    }
    
    
    
//    Book_Inner_ViewController * tab1 = [Book_Inner_ViewController new];
//
//    tab1.config = @{@"url": @{@"CMD_CODE": @"getListReadOfUser", @"book_type": @(1), @"price": @(0)}};
//
//    Book_Inner_ViewController * tab2 = [Book_Inner_ViewController new];
//
//    tab2.config = @{@"url": @{@"CMD_CODE": @"getListReadOfUser", @"book_type": @(2), @"price": @(0)}};
//
//    Book_Inner_ViewController * tab3 = [Book_Inner_ViewController new];
//
//    tab3.config = @{@"url": @{@"CMD_CODE": @"getListReadOfUser", @"book_type": @(3), @"price": @(0)}};

    controllers = cons;//[@[tab1, tab2, tab3] mutableCopy];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    for(UIView * v in viewPager.tabsView.subviews)
    {
        for(UIView * tab in v.subviews)
        {
            if([tab isKindOfClass:[UILabel class]])
            {
                ((UILabel*)tab).textColor = [viewPager.tabsView.subviews indexOfObject:v] == index ? [AVHexColor colorWithHexString:@"#00A34B"] : [UIColor blackColor];
            }
        }
    }
    
    self.indexSelected = [NSString stringWithFormat:@"%lu", (unsigned long)index];
}

- (IBAction)didPressMenu:(id)sender {
    [[self ROOT] toggleLeftPanel:sender];
}

- (IBAction)didPressSearch:(id)sender {
    [[self CENTER] pushViewController:[NN_Search_ViewController new] animated:YES];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs
{
    _numberOfTabs = numberOfTabs;
    
    [self reloadData];
}

#pragma mark - Helpers
- (void)loadContent
{
    self.numberOfTabs = [tabsName count];
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return self.numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    return [self modelLabel:index];
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    UIViewController * control = controllers[index];
    
    return control;
}

- (UILabel*)modelLabel:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    [self boldFontForLabel:label];
    label.text = tabsName[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

#pragma mark - ViewPagerDelegate

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case ViewPagerOptionStartFromSecondTab:
            return 0;
        case ViewPagerOptionCenterCurrentTab:
            return 0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 35.0;
        case ViewPagerOptionTabOffset:
            return 0;
        case ViewPagerOptionTabWidth:
            return ((self.view.frame.size.width) / 3);
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component)
    {
        case ViewPagerIndicator:
            return [AVHexColor colorWithHexString:@"#00A34B"];
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        case ViewPagerContent:
            [[UIColor blueColor] colorWithAlphaComponent:1];
        default:
            return color;
    }
}

-(void)boldFontForLabel:(UILabel *)label
{
//    UIFont *currentFont = label.font;
//    UIFont *newFont = [UIFont fontWithName: [NSString stringWithFormat:@"%@-Bold", currentFont.fontName] size:(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) ? 15 : 15];
    UIFont *newFont = [UIFont boldSystemFontOfSize:15];
    label.font = newFont;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
