//
//  LocationViewController.m
//  weatherRadio
//
//  Created by Backman on 2017/7/23.
//  Copyright © 2017年 Backman. All rights reserved.
//

#import "LocationViewController.h"
#import "WeatherInfoView.h"
#import "WeeklyDetailViewController.h"
@interface LocationViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet WeatherInfoView *weatherInfoView;

@end

@implementation LocationViewController{

    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.weatherInfoView showInfoByCity:@"Taiwan" Lat:[NSNumber numberWithDouble: 25.0] Lon:[NSNumber numberWithDouble:121.0] Date:[NSDate date]];
    

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated{
    self.locationManager.delegate = self;

}




#pragma city string search

- (void)startSearch:(NSString *)searchString {
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // Confine the map search area to the user's current location.
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userCoordinate.latitude;
    newRegion.center.longitude = self.userCoordinate.longitude;
    // delta value
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        if (error != nil) {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            
            self.places = [response mapItems];
            self.boundingRegion = response.boundingRegion;
            
            [self.cityTableView reloadData];
            [self.mapView setRegion:self.boundingRegion animated:YES];
            
            
            
            
            
            MKMapItem *mapItem = [self.places objectAtIndex:0];
            [self.weatherInfoView showInfoByCity:mapItem.name Lat:[NSNumber numberWithDouble: mapItem.placemark.location.coordinate.latitude] Lon:[NSNumber numberWithDouble:mapItem.placemark.location.coordinate.longitude] Date:[NSDate date]];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    
    if (self.localSearch != nil) {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}











#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // If the text changed, reset the tableview if it wasn't empty.
    if (self.places.count != 0) {
        
        // Set the list of places to be empty.
        self.places = @[];
        // Reload the tableview.
        [self.cityTableView reloadData];
    }
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    // Check if location services are available
    if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"%s: location services are not available.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services are not enabled on this device. Please enable location services in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}]; // Do nothing action to dismiss the alert.
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        // Display alert to the user.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location services"
                                                                       message:@"Location services were previously denied by the user. Please enable location services for this app in settings."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // Start updating locations.
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
   
}



#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Remember for later the user's current location.
    CLLocation *userLocation = locations.lastObject;
    self.userCoordinate = userLocation.coordinate;
    
    [manager stopUpdatingLocation]; // We only want one update.
    
    
    manager.delegate = nil;         // We might be called again here, even though we
    // called "stopUpdatingLocation", so remove us as the delegate to be sure.
    
    // We have a location now, so start the search.
    [self startSearch:self.searchBar.text];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // report any errors returned back from Location Services
}






#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityWeatherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cityWeatherCell"];
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    cell.cityName.text = mapItem.name;
    return cell;
}




//help function
- (UIImage*) renderMapToImage: (MKMapView*) mapView
{
    UIGraphicsBeginImageContext(mapView.frame.size);
    [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if([segue.identifier isEqualToString:@"weeklyDetail"]){
        NSIndexPath *indexPath = [self.cityTableView indexPathForSelectedRow];
        MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
        
        WeeklyDetailViewController * weeklyDetailCtler = segue.destinationViewController;
        weeklyDetailCtler.cityName = mapItem.name;
        weeklyDetailCtler.title = mapItem.name;
        weeklyDetailCtler.mapItem=mapItem;
        weeklyDetailCtler.snapShot=[self renderMapToImage:self.mapView];
    }

}






@end
