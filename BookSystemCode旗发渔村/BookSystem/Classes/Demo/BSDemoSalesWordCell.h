//
//  BSDemoSalesWordCell.h
//  BookSystem
//
//  Created by Stan Wu on 12-10-12.
//
//

#import <UIKit/UIKit.h>

@interface BSDemoSalesWordCell : UITableViewCell{
    UILabel *lblName;
    UITextView *tvDetail;
    
    NSDictionary *dicInfo;
}
@property (nonatomic,retain) NSDictionary *dicInfo;

@end
