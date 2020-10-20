//
//  ViewController.m
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/13/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceManager.h"
#import "CLPlacemark+CompleteAddress.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutViewNibControl.h"

@interface MainViewController () <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) CLLocation *bestLocation;
@property (nonatomic) CLLocationCoordinate2D *selectedLocationCoordinate;
@property (strong, nonatomic) NSString *selectedAddress;
@property (strong, nonatomic) UIButton *reCenterButton;
@property (strong, nonatomic) NSString *destinationCoordinateLatitude;
@property (strong, nonatomic) NSString *destinationCoordinateLongitude;
@property (strong, nonatomic) NSString *bestLocationAddress;
@property (strong, nonatomic) __block NSMutableArray *annotationContainer;

@end

@implementation MainViewController {
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet MKMapView *mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self checkAuthrization];
    [self fetchURLdata];
}

-(void)fetchURLdata {
    NSURL *url = [[NSURL alloc] initWithString:@"https://data.honolulu.gov/resource/yef5-h88r.json"];
    NSArray *allArtsArray = [[[ServiceManger alloc] init] requestWithURL:url];
    
    for (NSDictionary *singleArtWork in allArtsArray) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        if ((void)([singleArtWork valueForKey:@"latitude"] != nil),
            (void)([singleArtWork valueForKey:@"longitude"] != nil),
            [singleArtWork valueForKey:@"title"] != nil) {
            
            annotation.title = [singleArtWork valueForKey:@"title"];
            annotation.subtitle = @"dontDelete";
            CLLocationDegrees digitLatitude = [[singleArtWork valueForKey:@"latitude"] doubleValue];
            CLLocationDegrees digitLongitute = [[singleArtWork valueForKey:@"longitude"] doubleValue];
            annotation.coordinate = CLLocationCoordinate2DMake(digitLatitude, digitLongitute);
            [mapView addAnnotation:annotation];
            [self.annotationContainer addObject:annotation];
        }
    }
}

//MARK: - setUpViews
-(void)initializeMapViewNLocationManager { //could be merged?
    
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    mapView.showsCompass = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
}

-(void)searchBarNRecenterButtonSetUp {

    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"Search Places";

    self.reCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 750, 80, 50)];
    [self.reCenterButton setTitle:@"ReCenter" forState:UIControlStateNormal];
    [self.reCenterButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    self.reCenterButton.layer.zPosition = 100;
    
    self.reCenterButton.backgroundColor = UIColor.whiteColor;
    [self.reCenterButton addTarget:self
                            action:@selector(reCenterButtonTapped)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reCenterButton];
}

-(void)setUpViews {
//    NSNumber *longNumber = [[NSNumber alloc]initWithDouble:324235.23453643];
//    NSLog(@"%lld", longNumber);

    self.title = @"title";
    self.reCenterButton.layer.zPosition = 100;
    [self initializeMapViewNLocationManager];
    [self searchBarNRecenterButtonSetUp];   //name
}

//MARK: - mapview stuff
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationDegrees latitude = mapView.centerCoordinate.latitude;
    CLLocationDegrees longitute = mapView.centerCoordinate.longitude;
    NSLog(@"%f" @"%f", latitude, longitute);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    NSString *identifierAnnotationView = @"idAV";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifierAnnotationView];
    if (annotationView == nil) {
        annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifierAnnotationView];
        annotationView.canShowCallout = NO;
    } else {
        annotationView.annotation = annotation;
    }
    annotationView.image = [UIImage systemImageNamed:@"arrow.down"];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //anno coordinate
    if ([NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude].length > 6) {
        self.destinationCoordinateLatitude = [[NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude] substringWithRange:NSMakeRange(0, 6)];
    }
    if ([NSString stringWithFormat:@"%f", view.annotation.coordinate.latitude].length > 6) {
        self.destinationCoordinateLongitude = [[NSString stringWithFormat:@"%f", view.annotation.coordinate.longitude] substringWithRange:NSMakeRange(0, 6)];
    }
    
    //centered mapRegion
    CLLocationCoordinate2D toCenterCoordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude,
                                                                           view.annotation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(toCenterCoordinate, span);
    [mapView setRegion:region];
    
    //calloutView
    NSString *nibName = @"CustomCalloutNib";
    NSArray *views = [NSBundle.mainBundle loadNibNamed:nibName owner:nil options:nil];
    CustomCalloutViewNibControl *callOutView = views.firstObject; //uiviewClass
    [callOutView.bestLocationButton addTarget:self
                                       action: @selector(bestLocationButtonInCalloutViewTapped)
                             forControlEvents:UIControlEventTouchUpInside];
    
    [callOutView.destinationButton addTarget:self
                                      action:@selector(destinationButtonInCalloutViewTapped)
                            forControlEvents:UIControlEventTouchUpInside];
    
    callOutView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2 - 100);
    callOutView.layer.zPosition = 100;
    [view addSubview:callOutView];
    
    //popOut address
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *toCenterLocation = [[CLLocation alloc] initWithLatitude:toCenterCoordinate.latitude
                                                              longitude:toCenterCoordinate.longitude];
    [geoCoder reverseGeocodeLocation:toCenterLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        callOutView.titleLabel.text = placemarks.firstObject.phoneNumber;
        callOutView.subTitleLabel.text = placemarks.firstObject.importantInfo;
        if (error == nil && placemarks.firstObject) {
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        for (UIView *subview in view.subviews) { //logic of loop
            [subview removeFromSuperview];
        }
    }
}


//MARK: - locaiton stuff
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"%@", locations.lastObject);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error inside");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
}

-(void)checkAuthrization {
    switch (CLLocationManager.authorizationStatus) {

        case kCLAuthorizationStatusNotDetermined:
            [[self locationManager] requestAlwaysAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self showCenterOfUser];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self showCenterOfUser];
            break;
        default:
            break;
    }
}

-(void)showCenterOfUser {
    [[self locationManager] startUpdatingLocation];
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    MKCoordinateRegion region;
    region.span = span;
    region.center = coordinate;
    
    [mapView setRegion:region animated:YES];
}

//MARK: - searchBar stuff
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    NSString *trimmedSearchText = [searchText stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
//    if (searchText != trimmedSearchText) {
//        return;
//    }
    
    static dispatch_block_t pendingRequestBlock = nil;
    if (pendingRequestBlock != nil) {
        dispatch_block_cancel(pendingRequestBlock);
    }
    
    __weak typeof(self) weakSelf = self;
    pendingRequestBlock = dispatch_block_create(0, ^{
        [weakSelf resultLoader:trimmedSearchText];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   pendingRequestBlock);
}

-(void)resultLoader:(NSString *)forQuery {
    for (MKPointAnnotation *annotation in mapView.annotations) {
        if (![annotation.subtitle  isEqual: @"dontDelete"]) {
            [mapView removeAnnotation:annotation];
        }
    }
    NSLog(@"called");
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = forQuery;
    request.region = mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (response != nil) {
            for(MKMapItem *item in response.mapItems) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = item.phoneNumber;
                [self->mapView addAnnotation:annotation];
            }
        }
    }];
}

//MARK: - IBActions
- (void)reCenterButtonTapped {
    [self showCenterOfUser];
}

-(void)bestLocationButtonInCalloutViewTapped {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"For Best Location Title" message:@"For Best Location Message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)destinationButtonInCalloutViewTapped {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.destinationCoordinateLatitude message:self.destinationCoordinateLongitude preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:true completion:nil];
}

@end
