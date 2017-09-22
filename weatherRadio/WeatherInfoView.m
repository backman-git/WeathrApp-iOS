//
//  WeatherInfoView.m
//  weatherRadio
//
//  Created by Backman on 2017/7/24.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import "WeatherInfoView.h"




@implementation WeatherInfoView{

    WeatherData *_wd;
    NSDate *_queryDate;
}

@synthesize cityName =_cityName;
@synthesize temp = _temp;
@synthesize windSpeed=_windSpeed;
@synthesize cloud =_cloud;
@synthesize date =_date;
-(id) initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if(self){
    
        [[NSBundle mainBundle] loadNibNamed:@"WeatherInfoView" owner:self options:nil];
        self.bounds = self.view.bounds;
        
       
        [self addSubview:self.view];
        _wd  = [WeatherData sharedInstance];
        _wd.delegate =self;
        
    }
    return self;
}



-(id) initWithCoder:(NSCoder *)aDecoder{

    self =[super initWithCoder:aDecoder];
    if(self){
        [[NSBundle mainBundle] loadNibNamed:@"WeatherInfoView" owner:self options:nil];
       
        [self addSubview:self.view];
        _wd  = [WeatherData sharedInstance];
        _wd.delegate =self;
    }
    return self;
}

-(void) showInfoByCity:(NSString*) cityName Lat:(NSNumber*)lat Lon:(NSNumber*)lon Date: ( NSDate*)  date{
    
    _queryDate=date;
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:_queryDate];
    _date.text =strDate;
    _wd.delegate =self;



    [_wd queryCurrentWeatherByCity:cityName Lat:lat Lon:lon Date:_queryDate];
}





-(void)queryCompleted:(NSArray<Weather *> *)weathers{
    
    NSLog(@"query %@",weathers[0]);
    

    _cityName.text = weathers[0].city;
    _temp.text= [NSString stringWithFormat:@"%3.1f C",weathers[0].temp];
    _cloud.text=[NSString stringWithFormat:@"Cloud: %d%%",weathers[0].clouds];
    _windSpeed.text=[NSString stringWithFormat:@"WindSpeed: %3.1f m/s",weathers[0].windSpeed];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
