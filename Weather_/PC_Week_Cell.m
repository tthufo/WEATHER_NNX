//
//  PC_Week_Cell.m
//  HearThis
//
//  Created by Thanh Hai Tran on 7/26/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "PC_Week_Cell.h"

@interface PC_Week_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UICollectionView * collectionView;
        
    NSMutableArray * dataList;
}

@end

@implementation PC_Week_Cell

@synthesize data;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [collectionView withCell:@"Week_Cell"];
    
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
    
//    let daily = (self.weatherData as NSDictionary)["daily"] as! NSArray
//           let keys = ["temperatureHigh", "temperatureLow", "icon", "humidity", "time"]
//           var index = 0
//           for view in (self.withView(cell, tag: 11) as! UIStackView).subviews {
//               var indexing = 0
//               for subView in view.subviews {
//                   let tempa = (daily[index] as! NSDictionary).getValueFromKey(keys[indexing])
//                   if subView is UILabel {
//                       (subView as! UILabel).text = indexing == 4 ? self.returnDate(tempa) : self.returnVal(tempa, unit: indexing == 3 ? "%" : "°")
//                   } else {
//                       (subView as! UIImageView).image = UIImage.init(named: tempa!.replacingOccurrences(of: "-", with: "_"))
//                   }
//                   indexing += 1
//               }
//               index += 1
//           }
    
    [dataList removeAllObjects];
    
    NSDictionary * datas = data[@"daily"];
                    
    NSArray * keys = @[@"temperatureHigh", @"temperatureLow", @"icon", @"precipProbability", @"time"];

    for (NSDictionary * k in datas) {
        NSMutableDictionary * dict = [NSMutableDictionary new];
        for (NSString * ic in keys) {
            BOOL timer = [ic isEqualToString:@"time"];
            BOOL icon = [ic isEqualToString:@"icon"];
            BOOL percent = [ic isEqualToString:@"precipProbability"];
            dict[ic] = timer ? [self.parentViewController returnDate:k[ic]] : icon ? k[ic] : [self.parentViewController returnVal:k[ic] unit: percent ? @"%" : @"°"];
        }
        [dataList addObject:dict];
    }
                                
    [collectionView reloadData];
}

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Week_Cell" forIndexPath:indexPath];

    NSDictionary * dict = dataList[indexPath.row];
    
    UILabel * top = (UILabel*)[self withView:cell tag:1];

    top.text = [NSString stringWithFormat:@"%@", dict[@"temperatureHigh"]];

    UILabel * bot = (UILabel*)[self withView:cell tag:2];

    bot.text = [NSString stringWithFormat:@"%@", dict[@"temperatureLow"]];

    UIImageView * img = (UIImageView*)[self withView:cell tag:3];

    img.image = [UIImage imageNamed:[[dict getValueFromKey:@"icon"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];

    UILabel * rain = (UILabel*)[self withView:cell tag:4];

    rain.text = [dict getValueFromKey:@"precipProbability"];
    
    UILabel * timer = (UILabel*)[self withView:cell tag:5];

    timer.text = [dict getValueFromKey:@"time"];
    
    UIImageView * bg = (UIImageView*)[self withView:cell tag:90];

    bg.alpha = indexPath.row % 2 != 0;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.screenWidth / 7) - 0, 276);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
