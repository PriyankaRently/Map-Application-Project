//  ViewController.m
//  Map_Application
//
//  Created by Priyanka on 27/02/24.
//

#import "ViewController.h"

@interface ViewController () <MapTypeSelectionDelegate, UICollectionViewDelegate, UICollectionViewDataSource,ClcnViewCellDelegate>

//IBOutlets

@property (weak, nonatomic) IBOutlet UICollectionView *clcnView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *showMapTypeViewBtn;

//Properties

@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSArray<MKLocalSearchCompletion *> *searchResults;

// Arrays holding titles and image names for collection view.

@property (nonatomic, strong) NSArray<NSString *> *clcnViewBtnTitles;
@property (nonatomic, strong) NSArray<NSString *> *clcnViewBtnImageNames;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    [self setupSearchBar];
    [self setupCollectionView];
  //  [self setupLongPressGesture];
    
    self.showMapTypeViewBtn.layer.cornerRadius  = self.showMapTypeViewBtn.frame.size.width / 2.0;
    
    
    
}

- (IBAction)mapTypeDropDownButtonPressed:(id)sender {
    
    // Instantiate a storyboard and a viewController to display mapType options
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapTypeViewController *mapTypeVC = [storyBoard instantiateViewControllerWithIdentifier:@"MapTypeViewController"];
    mapTypeVC.delegate = self;
    [self presentViewController:mapTypeVC animated:YES completion:nil];
    
}

- (IBAction)seeMoreDetailsAlertPressed:(id)sender {
    
    // Creating an Alert and handling actions for Yes and No Options
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"do you want to see more details?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self viewDetailsButtonClicked:self.searchBar];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)directionPressed:(id)sender {
    
    if (self.mapView.userLocation.location) {
        
        CLLocation *currentLocation = self.mapView.userLocation.location;
        double currentLatitude = currentLocation.coordinate.latitude;
        double currentLongitude = currentLocation.coordinate.longitude;
        
        NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f", currentLatitude, currentLongitude];
        
        // Open Apple Map with constructed URL
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        
    } else {
        
        // Handling case where location is not available
        NSLog(@"User location not available.");
    }
}

- (IBAction)zoomStepperValueChanged:(UIStepper *)sender {
    
    double zoomLevel = sender.value;
    
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span;
    
    // Adjust the latitude and longitude deltas based on the zoom level
    span.latitudeDelta = 180.0 / pow(2, zoomLevel);
    span.longitudeDelta = 360.0 / pow(2, zoomLevel);
    
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}



#pragma mark - Setup Methods

- (void)setupLocationManager {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
}

- (void)setupSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"Search Bars, Clubs, Cafes";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.geocoder = [[CLGeocoder alloc] init];
    
}

- (void)setupCollectionView {
    
    [self.clcnView registerNib:[UINib nibWithNibName:@"ClcnViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ClcnViewCell"];
    self.clcnViewBtnTitles = @[@"Restaurant", @"Hospital", @"Libraries", @"Bakery", @"Cafe", @"Gym", @"SuperMarket", @"Bar", @"Hotels", @"Shopping",@"Petrol"];
    self.clcnViewBtnImageNames= @[@"resturent_icon", @"hospital_icon", @"library_Icon", @"bakery_icon", @"cafe_icon", @"gym_icon", @"superMarket_icon", @"bar_icon", @"hotels_icon", @"shopping_icon", @"petrol_icon"];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    // showing updated location on map
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100, 100);
    [mapView setRegion:region animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    // Checking if the annotation is of desired type
    if ([view.annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        // Retrieving annotation's details
        MKPointAnnotation *annotation = (MKPointAnnotation *)view.annotation;
        
        NSString *title = annotation.title;
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        
        //creating google Map URL
        NSString *encodedTitle = [title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *query = [NSString stringWithFormat:@"%f,%f,%@",  coordinate.latitude, coordinate.longitude, encodedTitle];
        
        NSString *googleMapsURLString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@", query];
        
        NSURL *url = [NSURL URLWithString:googleMapsURLString];
        
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
        
        // Presenting the Safari view controller
        [self presentViewController:safariViewController animated:YES completion:nil];
        
        
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.clcnViewBtnTitles.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ClcnViewCell *cell = (ClcnViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ClcnViewCell" forIndexPath:indexPath];
    
    NSString *title = self.clcnViewBtnTitles[indexPath.item];
    NSString *imageName = self.clcnViewBtnImageNames[indexPath.item];
    UIImage *image = [UIImage imageNamed:imageName];
    
    // Set image and title for the button
    [cell.button setImage:image forState:UIControlStateNormal];
    [cell.button setTitle:title forState:UIControlStateNormal];
    cell.delegate = self;
    
    return cell;
    
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if (searchText.length > 0) {
        // Performing search
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = searchText;
        
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        [self performLocalSearchWithQuery:searchText];
    }
}
#pragma mark - Custom Methods

- (void)performLocalSearchWithQuery:(NSString *)query {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Local search error: %@", error.localizedDescription);
        } else if (response.mapItems.count > 0) {
            [self.mapView removeAnnotations:self.mapView.annotations]; // Remove previous annotations
            for (MKMapItem *mapItem in response.mapItems) {
                [self addAnnotationForMapItem:mapItem];
            }
            [self zoomToFitAnnotations];
        } else {
            NSLog(@"No results found.");
        }
    }];
}


- (void)addAnnotationForMapItem:(MKMapItem *)mapItem {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = mapItem.placemark.coordinate;
    annotation.title = mapItem.name;
    [self.mapView addAnnotation:annotation];
}

// method to zoom to fit all annotation

- (void)zoomToFitAnnotations {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

-(void)didSelectMapType:(MKMapType)mapType {
    
    // Update the map type in the current view controller
    self.mapView.mapType = mapType;
}

//method to display additional details related to the search query entered in the search bar, when user will click on Yes in alert
- (void)viewDetailsButtonClicked:(UISearchBar *)searchBar {
    
    if (self.mapView.userLocation.location) {
        
        CLLocation *currentLocation = self.mapView.userLocation.location;
        double currentLatitude = currentLocation.coordinate.latitude;
        double currentLongitude = currentLocation.coordinate.longitude;
        
        NSString *searchText = searchBar.text;
        if (searchText.length > 0) {
            
            // Performing search
            MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
            request.naturalLanguageQuery = searchText;
            
            NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@&sll=%f,%f", [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], currentLatitude, currentLongitude];
            NSURL *url = [NSURL URLWithString:urlString];
            
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
            
            [self presentViewController:safariViewController animated:YES completion:nil];
        }
        
        // Resign the first responder status after constructing the URL and performing the search
        [searchBar resignFirstResponder];
    }
}

- (void)buttonPressedWithTitle:(NSString *)title {
    
    //setting collection view button's title to search bar
    
    self.searchBar.text = title;
    [self searchBarSearchButtonClicked:self.searchBar];
}

/*
 - (void)setupLongPressGesture {
 UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapLongPress:)];
 [self.mapView addGestureRecognizer:longPressGesture];
 }
 
 
 - (void)handleMapLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
 if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
     
 // Get the coordinates of the long press
 CGPoint longPressPoint = [gestureRecognizer locationInView:self.mapView];
 CLLocationCoordinate2D longPressCoordinate = [self.mapView convertPoint:longPressPoint toCoordinateFromView:self.mapView];
 
 // Initialize a geocoder object to perform reverse geocoding
 CLGeocoder *geocoder = [[CLGeocoder alloc] init];
 CLLocation *location = [[CLLocation alloc] initWithLatitude:longPressCoordinate.latitude longitude:longPressCoordinate.longitude];
 
 // Perform reverse geocoding to get the location's address details
 [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
 if (error) {
 NSLog(@"Reverse geocoding error: %@", error.localizedDescription);
 return;
 }
 
 // If reverse geocoding is successful, extract the place title from the placemark
 CLPlacemark *placemark = placemarks.firstObject;
 NSString *placeTitle = placemark.name; // You can use different properties of CLPlacemark to get more detailed location information
 
 if (placeTitle) {
 NSLog(@"Long press at: %@, Latitude: %f, Longitude: %f", placeTitle, longPressCoordinate.latitude, longPressCoordinate.longitude);
 
 // Create a Google Maps URL with the place title and coordinates
 NSString *encodedTitle = [placeTitle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
 NSString *query = [NSString stringWithFormat:@"%f,%f,%@", longPressCoordinate.latitude, longPressCoordinate.longitude, encodedTitle];
 NSString *googleMapsURLString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@", query];
 NSURL *url = [NSURL URLWithString:googleMapsURLString];
 
 // Open Google Maps URL in Safari view controller
 SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];
 [self presentViewController:safariViewController animated:YES completion:nil];
 } else {
 NSLog(@"No place title found for the long press location.");
 }
 }];
 }
 }
 
*/
@end

