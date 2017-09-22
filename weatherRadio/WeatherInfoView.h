//
//  WeatherInfoView.h
//  weatherRadio
//
//  Created by Backman on 2017/7/24.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@interface WeatherInfoView : UIView<WeatherDataDelegate>
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *temp;

@property (weak, nonatomic) IBOutlet UILabel *cloud;
@property (weak, nonatomic) IBOutlet UILabel *windSpeed;


-(void) showInfoByCity:(NSString*) cityName Lat:(NSNumber*)lat Lon:(NSNumber*)lon Date:(NSDate*)date;
@end
