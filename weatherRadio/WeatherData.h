//
//  WeatherData.h
//  weatherRadio
//
//  Created by Backman on 2017/7/22.
//  Copyright © 2017年 Backman. All rights reserved.
//

#ifndef WeatherData_h
#define WeatherData_h


#endif /* WeatherData_h */

#import <CoreData/CoreData.h>
#import "Weather+CoreDataClass.h"
#import "AppDelegate.h"



@protocol WeatherDataDelegate <NSObject>

@required
-(void) queryCompleted:(NSArray<Weather*>*) weathers;

@end



@interface WeatherData : NSObject{

    id <WeatherDataDelegate> _delegate;
    

}
@property (nonatomic,strong) id delegate;
@property(nonatomic) NSManagedObjectContext *context;
@property(nonatomic,weak) AppDelegate* appDelegate;

+(WeatherData*) sharedInstance;
-(void)createNewData:(NSNumber*)dt City:(NSString*) city Lat:(NSNumber*)lat Lon:(NSNumber*)lon;
-(void)queryCurrentWeatherByCity:(NSString*)city Lat:(NSNumber*)lat Lon:(NSNumber*)lon Date:(NSDate*)date;
-(void)fetch;
@end
