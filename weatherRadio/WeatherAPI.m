//
//  WeatherAPI.m
//  weatherRadio
//
//  Created by Backman on 2017/7/22.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

#define url @"api.openweathermap.org/data/2.5/weather?lat=35&lon=139"


//test sppid
#define SPPID @"b17f8bc2fd1efb4d624db9dffaaddd87"
#define API @"http://api.openweathermap.org/data/2.5/forecast?lat=%@&lon=%@&appid=%@&units=metric"
@interface WeatherAPI : NSObject{

    
        
    NSString* _sppid;
        
    

}


@end


@implementation WeatherAPI


+(WeatherAPI*) sharedInstance{
    static WeatherAPI* _instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _instance = [[WeatherAPI alloc] init];
        
        
    });
    return _instance;
}

-(id) init{
    
    self=[super init];
    _sppid = SPPID;
    
    return self;

}




-(void) fetchInfoByCityWithCompletionBlock:( void (^)(NSDictionary *DataArray,NSError *error)) completionBlock City:(NSString*) cityName Lat:(NSNumber*)lat Lon:(NSNumber*)lon{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                          delegate: nil
                                                     delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *dataURL = [NSURL URLWithString:[NSString stringWithFormat:API,[lat stringValue],[lon stringValue],SPPID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response,
                                    NSError *error)
      {
          NSLog(@"Got response %@ with error %@.\n", response, error);
          NSDictionary *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          completionBlock (dataArray, error);
      }
      ]resume];
    



}


-(void) fetchCurrentLocationWithCompletionBlock:( void (^)(NSArray *DataArray,NSError *error)) completionBlock
{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil
                                                                 delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *dataURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b1b15e88fa797225412429c1c50c122a1"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    
    [[session dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response,
                                                NSError *error)
      {
          NSLog(@"Got response %@ with error %@.\n", response, error);
          NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          completionBlock (dataArray, error);
      }
      ]resume];
    
    
    
    
}








@end
