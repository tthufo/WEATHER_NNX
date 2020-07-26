//
//  PC_Day_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 7/26/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Day_Cell.h"

@interface PC_Day_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UICollectionView * collectionView;
        
    NSMutableArray * dataList;
}

@end

@implementation PC_Day_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [collectionView withCell:@"Day_Cell"];
    
    dataList = [NSMutableArray new];
        
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (data.allKeys.count != 0) {
            [self getData];
        }
        
        [self didReloadData];

    });
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

           if (data.allKeys.count != 0) {
                 [self getData];
             }
       });
}

- (void)didReloadData {
    [collectionView reloadData];
}

- (void)getData {
    
    [dataList removeAllObjects];
    
    NSDictionary * datas = data[@"currently"];
                
    NSArray * keys = @[
        @{@"key":@"humidity", @"unit": @"%", @"img": @"ico_humidity_2", @"name":@"Độ ẩm"},
        @{@"key":@"uvIndex",  @"unit": @"UV", @"img": @"ico_uv", @"name":@"Chỉ số UV"},
                @{@"key":@"windSpeed", @"unit": @"km/h", @"img":@"ico_wind_2", @"name":@"Tốc độ gió"},
                @{@"key":@"precipIntensity", @"unit": @"mm", @"img":@"ico_rain", @"name":@"Lượng mưa"},
                @{@"key":@"dewPoint", @"unit": @"°", @"img":@"ico_dewpoint", @"name":@"Điểm sương"},
                @{@"key":@"pressure", @"unit": @"mb", @"img":@"ico_pressure", @"name":@"Áp suất"},
    ];
            
//    NSMutableArray * arr = [NSMutableArray new];
            
    for (NSDictionary * k in keys) {
        [dataList addObject:@{@"val": [datas getValueFromKey: k[@"key"]], @"unit": k[@"unit"], @"img":  k[@"img"], @"name": k[@"name"]}];
    }
    
    NSLog(@"+++%@", dataList);
                            
    [collectionView reloadData];
}



//- (NSString*)returnVal:(NSString*)val {
//    return [NSString stringWithFormat:@"%.02f", [val floatValue]];
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Day_Cell" forIndexPath:indexPath];

    NSDictionary * dict = dataList[indexPath.row];
    
    UILabel * percent = (UILabel*)[self withView:cell tag:10];
    
    percent.text = [NSString stringWithFormat:@"%@", [self.parentViewController returnVal:[dict getValueFromKey:@"val"] unit:[dict getValueFromKey:@"unit"]]];
    
    UIImageView * img = (UIImageView*)[self withView:cell tag:11];

    img.image = [UIImage imageNamed:[dict getValueFromKey:@"img"]];
    
    UILabel * rain = (UILabel*)[self withView:cell tag:12];
    
    rain.text = [dict getValueFromKey:@"name"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.screenWidth / 3) - 0, self.screenWidth / 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
