//
//  VideoCell.h
//  php_ios
//
//  Created by mac on 2018/4/1.
//  Copyright © 2018年 aoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoCell : UITableViewCell

@property (nonatomic, strong) VideoModel  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
