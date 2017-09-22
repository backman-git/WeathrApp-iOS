//
//  LocationViewController.h
//  weatherRadio
//
//  Created by Backman on 2017/7/23.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CityWeatherCell.h"


@interface LocationViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSArray *places;

@property (nonatomic, strong) NSArray *mapItemList;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@end
