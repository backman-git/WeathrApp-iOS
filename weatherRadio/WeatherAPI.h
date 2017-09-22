//
//  WeatherAPI.h
//  weatherRadio
//
//  Created by Backman on 2017/7/22.
//  Copyright © 2017年 Backman. All rights reserved.
//

#ifndef WeatherAPI_h
#define WeatherAPI_h


@interface WeatherAPI : NSObject

+(WeatherAPI*) sharedInstance;
//-(void) fetchCurrentLocationWithCompletionBlock:( void (^)(NSArray *DataArray,NSError *error)) completionBlock;
-(void) fetchInfoByCityWithCompletionBlock:( void (^)(NSDictionary *DataArray,NSError *error)) completionBlock City:(NSString*) cityName Lat:(NSNumber*)lat Lon:(NSNumber*)lon;

@end




#endif /* WeatherAPI_h */



