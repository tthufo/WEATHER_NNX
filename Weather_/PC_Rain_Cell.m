//
//  PC_Rain_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 5/17/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Rain_Cell.h"

#include <math.h>

@interface PC_Rain_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UIButton * daily, * weekLy;
    
    IBOutlet UILabel * rainy;
    
    IBOutlet UICollectionView * collectionView;
    
    BOOL day;
    
    NSMutableArray * dataList;
}

@end

@implementation PC_Rain_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [collectionView withCell:@"Rainy_Cell"];
    
    dataList = [NSMutableArray new];
    
    [self optional];
    
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

- (IBAction)didPressOption:(UIButton*)button {
    day = button.tag != 11;
    [self optional];
    [self getData];
}

- (void)optional {
    [daily withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#5530F5" : @"#FFFFFF"], @"Bwidth": !day ? @"1" : @"0", @"Bcorner": @"16"}];
    [weekLy withBorder:@{@"Bcolor": [self color: @"#5530F5"], @"Bground": [self color: !day ? @"#FFFFFF" : @"5530F5"], @"Bwidth": !day ? @"0" : @"1", @"Bcorner": @"16"}];
    
    [daily setTitleColor:[self color: !day ? @"#FFFFFF" : @"#5530F5"] forState:UIControlStateNormal];
    [weekLy setTitleColor:[self color: !day ? @"#5530F5" : @"#FFFFFF"] forState:UIControlStateNormal];
}

- (UIColor*)color:(NSString*)color {
    return [AVHexColor colorWithHexString:color];
}

- (void)getData {
    
    [dataList removeAllObjects];
            
    for (int i = 0; i < (!day ? 24 : ((NSArray*)data[@"daily"]).count) ; i++)
    {
        [dataList addObject:((NSArray*)self.data[!day ? @"hourly" : @"daily"])[i]];
    }
    
    [collectionView reloadData];
        
    rainy.text = [NSString stringWithFormat:@"Tổng lượng mưa trong ngày %@", [self returnVal:data[@"currently"][@"precipIntensity"]]];
}

- (NSString*)returnVal:(NSString*)val {
    return [NSString stringWithFormat:@"%.02f", [val floatValue]];
}

- (NSString*)returnTime:(NSString*)val {
    if (!day) {
        return [[val componentsSeparatedByString:@" "] firstObject];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];

    return [[[val componentsSeparatedByString:@" "] firstObject] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", year] withString:@""];
}

- (NSString*)returnImg:(int)rainValue {
    if (rainValue <= 0) {
        return @"ic_rain_drop_0";
    } else if (rainValue <= 10) {
        return @"ic_rain_drop_10";
    } else if (rainValue <= 25) {
        return @"ic_rain_drop_25";
    } else if (rainValue <= 50) {
        return @"ic_rain_drop_50";
    } else if (rainValue <= 75) {
        return @"ic_rain_drop_75";
    } else if (rainValue <= 99) {
        return @"ic_rain_drop_90";
    } else {
        return @"ic_rain_drop_100";
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Rainy_Cell" forIndexPath:indexPath];

    NSDictionary * dict = dataList[indexPath.row];
    
    UILabel * percent = (UILabel*)[self withView:cell tag:11];
    
    percent.text = [NSString stringWithFormat:@"%@ %@", [dict getValueFromKey:@"precipProbability"], @"%"];
    
    UIImageView * img = (UIImageView*)[self withView:cell tag:12];
    
    img.image = [UIImage imageNamed:[self returnImg: [[dict getValueFromKey:@"precipProbability"] intValue]]];

    UILabel * rain = (UILabel*)[self withView:cell tag:13];
    
//    rain.text = [self returnVal:[dict getValueFromKey:@"precipIntensity"]];

    rain.text = [self returnTime:[dict getValueFromKey:@"time"]];

//    UILabel * time = (UILabel*)[self withView:cell tag:14];

//    time.text = [self returnTime:[dict getValueFromKey:@"time"]];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 130);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
