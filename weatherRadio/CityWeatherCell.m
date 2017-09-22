//
//  CityWeatherCell.m
//  weatherRadio
//
//  Created by Backman on 2017/7/23.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import "CityWeatherCell.h"

@implementation CityWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateCell:(NSString*)cityName{
    
    self.cityName.text= cityName;



}





@end
