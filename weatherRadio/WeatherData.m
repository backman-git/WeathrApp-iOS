//
//  WeatherData.m
//  weatherRadio
//
//  Created by Backman on 2017/7/22.
//  Copyright © 2017年 Backman. All rights reserved.
//


//should be singlton


#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import "AppDelegate.h"
#import "WeatherAPI.h"






@interface WeatherData (){

    NSArray<Weather*>* _weatherBuff;
    WeatherAPI* _weatherAPI;
}


@end


@implementation WeatherData : NSObject

+(WeatherData*) sharedInstance{
    static WeatherData* _instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[WeatherData alloc] init];
        
        
    });
    return _instance;
}

-(id)init{
    
    if (! (self=[super init]))
        return nil;
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context=self.appDelegate.persistentContainer.viewContext;
    _weatherAPI = [[WeatherAPI alloc] init];
    return self;
}


-(void)queryCurrentWeatherByCity:(NSString*)city Lat:(NSNumber*)lat Lon:(NSNumber*)lon Date:(NSDate*)qDate{
    //1. check buffer letter
    /*
    if ([_weatherBuff count]!=0){
        
        Weather* w0 =[_weatherBuff objectAtIndex:0];
        if([w0.city isEqualToString:city]){
            NSLog(@"in buf");
            [_delegate queryCompleted:_weatherBuff];
            return ;
        }
    }
    */
    //2. fetch from DB
   // NSLog(@"%@ %@",[NSString stringWithFormat:@"%d" ,(int)[date timeIntervalSince1970]],[NSString stringWithFormat:@"%d" ,(int)[[date dateByAddingTimeInterval:3*60*60] timeIntervalSince1970]]);
    _weatherBuff = [self fetchFromDB:[NSPredicate predicateWithFormat:@"city = %@ AND dt BETWEEN {%@,%@}",city,[NSString stringWithFormat:@"%ld" ,(long int)[qDate timeIntervalSince1970]], [NSString stringWithFormat:@"%ld" ,(long int)([qDate timeIntervalSince1970]+3*60*60)]]];
   
    //3. fetch from service aysn
    if ([_weatherBuff count]==0){
        
        [_weatherAPI fetchInfoByCityWithCompletionBlock:^(NSDictionary *DataArray, NSError *error) {
            
            // update DB;
            NSLog(@"in net");
            NSMutableArray<Weather*>* res=[[NSMutableArray<Weather*> alloc] init];
            for(id obj in DataArray[@"list"]){
                Weather* weather =[[Weather alloc] initWithContext:self.context];
                weather.dt=(int) [obj[@"dt"] integerValue];
                weather.city= city;
                weather.lat=[lat doubleValue];
                weather.lon=[lon doubleValue];
                //weather.rain=obj[@""]
                weather.clouds=(int)[obj[@"clouds"][@"all"] integerValue];
                weather.temp=(float)[obj[@"main"][@"temp"] floatValue];
                weather.tempMax=(float)[obj[@"main"][@"temp_max"] floatValue];
                weather.tempMin=(float)[obj[@"main"][@"temp_min"] floatValue];
                weather.windDeg=(float)[obj[@"wind"][@"deg"] floatValue];
                weather.windSpeed=(float)[obj[@"wind"][@"speed"] floatValue];
                
                if ((int)[qDate timeIntervalSince1970]<=weather.dt && weather.dt <(int)([qDate timeIntervalSince1970]+3*60*60)){
                    [res addObject:weather];
                }
                [self save];
            }
            
            [_delegate queryCompleted:res];
        } City:city Lat:lat Lon:lon];
        
        return ;
        
    }
    NSLog(@"in DB");
    [_delegate queryCompleted:_weatherBuff];
    return ;

}

-(NSArray*)fetchFromDB:(NSPredicate*) predicate{

    //2. fetch from DB
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.predicate=predicate;
    //syn
    return [self.context executeFetchRequest:request  error:nil];

}






-(void)createNewData:(NSNumber*)dt City:(NSString*) city Lat:(NSNumber*)lat Lon:(NSNumber*)lon{

    Weather* weather =[[Weather alloc] initWithContext:self.context];
    weather.city = city;
    weather.lat= [lat doubleValue];
    weather.lon= [lon doubleValue];
    
    [self save];
}



//debug usage
-(void)print:(NSArray<Weather*>*) weathers{
    
    for(Weather * weather in weathers){
        
        NSLog(@"%f %f %@",weather.lat,weather.lon,weather.city);
        
        
    }
    
}





- (void)save {
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
      
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
}





@end
