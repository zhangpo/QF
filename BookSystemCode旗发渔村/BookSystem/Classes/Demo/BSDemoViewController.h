//
//  BSDemoViewController.h
//  BookSystem
//
//  Created by Stan Wu on 12-10-10.
//
//

#import <UIKit/UIKit.h>
#import "BSDemoResvCell.h"
#import "BSDemoSalesCell.h"
#import "BSDemoSalesWordCell.h"
#import "BSDemoChartCell.h"
#import "SWPieChart.h"

typedef enum {
    BSDemoListResv,
    BSDemoListSales,
    BSDemoListSaleWord,
    BSDemoListIncomeChart,
    BSDemoListSalesChart
}BSDemoList;

#define kDemoCellHeight     28.0f

@interface BSDemoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BSResvDelegate,UISearchBarDelegate>{
    UIViewController *vcLeft,*vcRight;
    UITableView *tvLeft,*tvRight;
    UIView *vChart;
    
    NSDictionary *dicInfo;
    BSDemoList listType;
    NSInteger selectedIndex;
    NSMutableArray *aryResult;
}
@property (nonatomic,retain) NSDictionary *dicInfo;
@property (nonatomic,retain) NSMutableArray *aryResult;

@end
