//
//  MapTypeViewController.m
//  RevisionMap
//
//  Created by Priyanka on 11/03/24.
//

#import "MapTypeViewController.h"

typedef NS_ENUM(NSUInteger, MapType) {
          MapTypeStandard = 0,
          MapTypeSatellite = 1,
          MapTypeHybrid = 2
          
};

@interface MapTypeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *hybridLabel;
@property (weak, nonatomic) IBOutlet UILabel *satelliteLabel;
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation MapTypeViewController

- (void)viewDidLoad {
          [super viewDidLoad];
          // Do any additional setup after loading the view.
}

#pragma mark - IBActions

- (IBAction)mapTypeButtonPressed:(UIButton *)sender {
    
    // Handling button press event to select different map types and notify the delegate and also changing color of text in label to blue here.
    
          [self resetLabelColors];
    
           MapType mapType;
          
          switch (sender.tag) {
                    case MapTypeHybrid:
                              self.selectedLabel = self.hybridLabel;
                              mapType = MapTypeHybrid;
                              break;
                    case MapTypeSatellite:
                              self.selectedLabel = self.satelliteLabel;
                              mapType = MapTypeSatellite;
                              break;
                    case MapTypeStandard:
                              self.selectedLabel = self.standardLabel;
                              mapType = MapTypeStandard;
                              break;
                    default:
                              break;
          }
          
          self.selectedLabel.textColor = [UIColor blueColor];
          
          if ([self.delegate respondsToSelector:@selector(didSelectMapType:)]) {
                    [self.delegate didSelectMapType:mapType];
          }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Helper Methods

- (void)resetLabelColors {
          
          self.hybridLabel.textColor = [UIColor blackColor];
          self.satelliteLabel.textColor = [UIColor blackColor];
          self.standardLabel.textColor = [UIColor blackColor];
}

@end
