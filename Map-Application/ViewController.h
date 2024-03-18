//
//  ViewController.h
//  Map_Application
//
//  Created by Priyanka on 27/02/24.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapTypeViewController.h"
#import "SafariServices/SafariServices.h"
#import "ClcnViewCell.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
    
    CLLocationManager *locationManager;
    
    
}


@end

