//
//  ClcnViewCell.m
//  RevisionMap
//
//  Created by Priyanka on 15/03/24.
//

#import "ClcnViewCell.h"

@implementation ClcnViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    // Setting rounded corners for the view container
    
    self.viewContainer.layer.cornerRadius = self.viewContainer.frame.size.height / 2.0;
    self.viewContainer.clipsToBounds = YES;
    
}

- (IBAction)clcnButtonPressed:(id)sender {
    
         // Getting  title of the button that was pressed and calling the delegate method
    
          NSString *title = [sender titleForState:UIControlStateNormal];
          [self.delegate buttonPressedWithTitle:title];
    
}

@end
