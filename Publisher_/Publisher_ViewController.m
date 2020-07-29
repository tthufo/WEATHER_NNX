//
//  HT_Search_ViewController.m
//  HearThis
//
//  Created by Thanh Hai Tran on 10/4/16.
//  Copyright © 2016 Thanh Hai Tran. All rights reserved.
//

#import "Publisher_ViewController.h"

#import "NNX-Swift.h"

@interface Publisher_ViewController ()
{
    IBOutlet UILabel * titleLabel;

    IBOutlet UITableView * tableView;
    
    UIRefreshControl * refreshControl;
    
    NSMutableArray * dataList;
        
    int pageIndex;
    
    int totalPage;
    
    BOOL isLoadMore;
}

@end

@implementation Publisher_ViewController

@synthesize config;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self didEmbed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageIndex = 1;
    
    totalPage = 1;
    
    dataList = [NSMutableArray new];
    
    [tableView withCell: @"Publisher_Cell"];
    
    [tableView withCell: @"Publisher_Cell_Large"];
    
    tableView.rowHeight = UITableViewAutomaticDimension;

    tableView.estimatedRowHeight = IS_IPAD ? 245 : 150;
    
    refreshControl = [UIRefreshControl new];
    
    tableView.refreshControl = refreshControl;
    
    [refreshControl addTarget:self action:@selector(didReloadData) forControlEvents:UIControlEventValueChanged];
        
    [self didRequestData:YES];
}

- (NSString *)inform:(NSString *)content {

    NSString * tempString = [NSString stringWithFormat:@"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size:17 \">%@</span>", content];
    
    return tempString;
}

- (void)didReloadData
{
    isLoadMore = NO;
    pageIndex = 1;
    totalPage = 1;
    [self didRequestData:YES];
}

- (void)didRequestData:(BOOL)isShow
{
    NSMutableDictionary * request = [[NSMutableDictionary alloc] initWithDictionary:@{@"session":Information.token,
                                                                                      @"page_index": @(pageIndex),
                                                                                      @"page_size": @(12),
                                                                                      @"overrideError":@"1",
                                                                                      @"overrideLoading":@"1",
                                                                                      @"host":self}];
    [request addEntriesFromDictionary:self.config];
    
    [[LTRequest sharedInstance] didRequestInfo:request withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSString* errorCode, NSError *error, BOOL isValidated, NSDictionary * object) {
        
        [refreshControl endRefreshing];
        
        [tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];
                
        if(isValidated)
        {
            NSDictionary * dict = [responseString objectFromJSONString];
                        
            if (![dict[@"result"] isEqual:[NSNull null]]) {

                totalPage = [dict[@"result"][@"total_page"] intValue];
                  
                pageIndex += 1;
                  
                if(!isLoadMore)
                {
                    [dataList removeAllObjects];
                }
                
                [dataList addObjectsFromArray:dict[@"result"][@"data"]];
            } else {
                 [self showToast:[[dict getValueFromKey:@"error_msg"] isEqualToString:@""] ? @"Lỗi xảy ra, mời bạn thử lại" : [dict getValueFromKey:@"error_msg"] andPos:0];
            }
        }
        
        [tableView reloadData];
        
    }];
}

- (NSDictionary *)removeKey:(NSMutableDictionary *)info {
    [(NSMutableDictionary*)info[@"url"] removeObjectsForKeys:@[@"page_index", @"page_size"]];
    return info;
}

- (IBAction)didPressBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableView

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;

//    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier: IS_IPAD ? @"Publisher_Cell_Large" : @"Publisher_Cell" forIndexPath:indexPath];
    
    NSDictionary * list = dataList[indexPath.row];
    
    [(UIImageView*)[self withView:cell tag:1] imageUrlHolderWithUrl:[list getValueFromKey:@"avatar"] holder:@"bg_publisher_default_img"];
    
    [(UILabel*)[self withView:cell tag:2] setText: [list getValueFromKey:@"name"]];

    [(UILabel*)[self withView:cell tag:3] setText: [NSString stringWithFormat:@"%@ tác phẩm", [list getValueFromKey:@"book_count"]]];

    ((UITextView*)[self withView:cell tag:22]).text = [self attributeHTMLRaw:[list getValueFromKey:@"info"]];

    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary * list = dataList[indexPath.row];

    List_Book_ViewController * listBook = [List_Book_ViewController new];
        
    listBook.config = @{@"url": @{@"CMD_CODE": @"getListBook", @"book_type": @(0), @"price": @(0), @"sorting": @(1), @"publishing_house_id": @([list getValueFromKey: @"id"].intValue)}, @"title": [list getValueFromKey:@"name"], @"counter": @"1"};
    
    [self.navigationController pushViewController:listBook animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (pageIndex == 1) {
        return;
    }
    
    if (indexPath.row == dataList.count - 1) {
        if (pageIndex <= totalPage) {
            isLoadMore = YES;
            [self didRequestData:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
