//
//  ClcnViewCell.h
//  RevisionMap
//
//  Created by Priyanka on 15/03/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ClcnViewCellDelegate <UICollectionViewDelegate>

- (void)buttonPressedWithTitle:(NSString *)title;

@end

@interface ClcnViewCell : UICollectionViewCell

//IBOutlets

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, weak) id<ClcnViewCellDelegate> delegate;

//IBAction

- (IBAction)clcnButtonPressed:(id)sender;

@end

NS_ASSUME_NONNULL_END
