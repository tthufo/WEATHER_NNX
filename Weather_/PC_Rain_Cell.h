//
//  PC_Rain_Cell.h
//  HearThis
//
//  Created by Thanh Hai Tran on 5/17/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PC_Rain_Cell : UITableViewCell

@property (nonatomic, assign) NSDictionary * data;

- (void)didReloadData;

@end

NS_ASSUME_NONNULL_END
