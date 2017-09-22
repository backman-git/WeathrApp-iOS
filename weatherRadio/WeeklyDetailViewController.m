//
//  WeeklyDetailViewController.m
//  weatherRadio
//
//  Created by Backman on 2017/7/24.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import "WeeklyDetailViewController.h"

@interface WeeklyDetailViewController ()

@end

@implementation WeeklyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // five days (api limit)
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WeeklyDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"weeklyDetailCell"];
    [cell.weatherInfoView showInfoByCity:self.mapItem.name Lat:[NSNumber numberWithDouble: self.mapItem.placemark.location.coordinate.latitude] Lon:[NSNumber numberWithDouble:self.mapItem.placemark.location.coordinate.longitude] Date:[[NSDate date] dateByAddingTimeInterval:24*60*60*indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ self.snapShot stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] ];
    cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ self.snapShot stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] ];

    
    return cell;
}



@end
