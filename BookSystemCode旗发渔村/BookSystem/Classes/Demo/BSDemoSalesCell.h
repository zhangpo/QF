//
//  BSDemoSalesCell.h
//  BookSystem
//
//  Created by Stan Wu on 12-10-12.
//
//

#import <UIKit/UIKit.h>

@interface BSDemoSalesCell : UITableViewCell{
    UILabel *lblName,*lblUnit,*lblPrice,*lblPlan,*lblSold,*lblLeft,*lblLeftRatio;
    
    NSDictionary *dicInfo;
}
@property (nonatomic,retain) NSDictionary *dicInfo;

@end
