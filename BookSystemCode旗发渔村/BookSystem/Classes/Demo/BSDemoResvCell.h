//
//  BSDemoResvCell.h
//  BookSystem
//
//  Created by Stan Wu on 12-10-11.
//
//

#import <UIKit/UIKit.h>

@class BSDemoResvCell;

@protocol BSResvDelegate

- (void)cellNeedsRefresh:(BSDemoResvCell *)cell;

@end

@interface BSDemoResvCell : UITableViewCell{
    UIView *vBasic,*vDetail;
    UILabel *lblFirm,*lblTele,*lblNam,*lblTim,*lblVIP;
    UIImageView *imgvVIP;
    UIButton *btnShowMore,*btnEdit;
    UILabel *lblSub,*lblMemo,*lblPax,*lblEmp,*lblTbl,*lblKouwei,*lblXihao,*lblChedan,*lblQita;
    UITextField *tfKouwei,*tfXihao,*tfChedan,*tfQita;
    
    BOOL bShowDetail,bBeginEdit;
    NSDictionary *dicInfo;
    id<BSResvDelegate> delegate;
}
@property BOOL bShowDetail,bBeginEdit;
@property (nonatomic,retain) NSDictionary *dicInfo;
@property (nonatomic,assign) id<BSResvDelegate> delegate;

- (void)refreshLayout;

@end
