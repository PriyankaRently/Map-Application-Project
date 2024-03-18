//
//  MapTypeViewController.h
//  RevisionMap
//
//  Created by Priyanka on 11/03/24.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MapTypeSelectionDelegate <NSObject>

-(void)didSelectMapType:(MKMapType)mapType;

@end

@interface MapTypeViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) id<MapTypeSelectionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
