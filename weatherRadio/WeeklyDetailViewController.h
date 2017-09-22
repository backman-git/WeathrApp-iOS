//
//  WeeklyDetailViewController.h
//  weatherRadio
//
//  Created by Backman on 2017/7/24.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WeeklyDetailCell.h"

@interface WeeklyDetailViewController : UITableViewController

@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) MKMapItem *mapItem;
@property (nonatomic,strong) UIImage* snapShot;
@end
