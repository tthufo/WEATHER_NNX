//
//  PC_Week_Cell.h
//  HearThis
//
//  Created by Thanh Hai Tran on 7/26/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PC_Week_Cell : UITableViewCell

@property (nonatomic, assign) NSDictionary * data;

- (void)didReloadData;

@end

NS_ASSUME_NONNULL_END
