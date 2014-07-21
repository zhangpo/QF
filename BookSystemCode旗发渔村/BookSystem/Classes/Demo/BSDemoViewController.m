//
//  BSDemoViewController.m
//  BookSystem
//
//  Created by Stan Wu on 12-10-10.
//
//

#import "BSDemoViewController.h"

@interface BSDemoViewController ()

@end

@implementation BSDemoViewController
@synthesize dicInfo,aryResult;

- (void)dealloc{
    self.dicInfo = nil;
    self.aryResult = nil;
    
    [vChart release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"服务功能";
    self.aryResult = [NSMutableArray array];
    
    selectedIndex = -1;
    vcLeft = [[UIViewController alloc] init];
    vcLeft.navigationItem.title = @"服务功能";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcLeft];
    [vcLeft release];
    nav.view.frame = CGRectMake(0, 0, 300, 1004);
    [self.view addSubview:nav.view];
    vcLeft.view.backgroundColor = [UIColor colorWithRed:.84 green:.85 blue:.87 alpha:1];
    vcLeft.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(removeSelf)] autorelease];
    
    vcRight = [[UIViewController alloc] init];
    vcRight.navigationItem.title = @"预订列表";
    nav = [[UINavigationController alloc] initWithRootViewController:vcRight];
    [vcRight release];
    nav.view.frame = CGRectMake(300, 0, 468, 1004);
    [self.view addSubview:nav.view];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    vcRight.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchBar] autorelease];
    searchBar.delegate = self;
    
    tvLeft = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 1004-44)];
    tvLeft.delegate = self;
    tvLeft.dataSource = self;
    [vcLeft.view addSubview:tvLeft];
    [tvLeft release];
    tvLeft.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvLeft.backgroundColor = [UIColor clearColor];
    
    tvRight = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 468, 1004-44)];
    tvRight.delegate = self;
    tvRight.dataSource = self;
    [vcRight.view addSubview:tvRight];
    [tvRight release];
    
    [tvLeft selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    self.dicInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"plist"]];
//
//    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"预定列表",@"销售情况",@"营销词汇",@"营收报表",@"销售报表", nil]];
//    seg.segmentedControlStyle = UISegmentedControlStyleBordered;
//    seg.center = CGPointMake(270, 30);
//    [self.view addSubview:seg];
//    [seg release];
//    [self performSelector:@selector(showMyFrame) withObject:nil afterDelay:0.1f];
//    [seg addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
//    [seg setSelectedSegmentIndex:0];
//    
//    tvList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 540, 516)];
//    tvList.delegate = self;
//    tvList.dataSource = self;
//    [self.view addSubview:tvList];
//    [tvList release];
    
}

- (void)removeSelf{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSArray *ary = nil;
    
    ary = BSDemoListResv==listType?[[dicInfo objectForKey:@"ResvList"] objectForKey:@"Resv"]:(BSDemoListSaleWord==listType?[dicInfo objectForKey:@"MemoList"]:nil);
    NSArray *titles = [@"预订列表,销售状况,销售词汇,营收报表,销售报表" componentsSeparatedByString:@","];
    vcRight.navigationItem.title = [titles objectAtIndex:2];
    
    [aryResult removeAllObjects];
    if (searchText.length>0){
        for (int i=0;i<ary.count;i++){
            NSDictionary *dict = [ary objectAtIndex:i];
            NSString *nam = [dict objectForKey:@"Nam"];
            NSString *tele = [dict objectForKey:@"Tele"];
            NSRange range0,range1;
            range0 = [nam rangeOfString:searchText];
            range1 = [tele rangeOfString:searchText];
            if (range0.location!=NSNotFound || range1.location!=NSNotFound)
                [aryResult addObject:dict];
        }
    }
    
    
    [tvRight reloadData];
}

- (void)cellNeedsRefresh:(BSDemoResvCell *)cell{
    NSIndexPath *indexPath = [tvRight indexPathForCell:cell];
    
    selectedIndex = cell.bShowDetail?indexPath.row:-1;

    [tvRight reloadData];
}

- (void)showMyFrame{
    NSLog(@"%@ Frame:%@",[self class],NSStringFromCGRect(self.view.frame));
}

- (void)typeChanged:(UISegmentedControl *)seg{
    NSLog(@"Changed To Index:%d",seg.selectedSegmentIndex);
    listType = seg.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)heightForCell:(NSIndexPath *)indexPath{
    switch (listType) {
        case BSDemoListResv:{
            if (selectedIndex==indexPath.row)
                return 130+225;
            else
                return 130;
        }
            break;
        case BSDemoListSales:
            return 130;
            break;
        case BSDemoListSaleWord:
            return 130;
            
        default:
            return kDemoCellHeight;
            break;
    }
    return kDemoCellHeight;
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (tableView==tvLeft){
        static NSString *identifierL = @"LeftCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifierL];
        if (!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierL] autorelease];
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(0, 0, tvLeft.frame.size.width, 60) font:[UIFont systemFontOfSize:18]];
            lbl.textAlignment = UITextAlignmentCenter;
            [cell.contentView addSubview:lbl];
            lbl.tag = 100;
            
            cell.backgroundView = [[[UIView alloc] init] autorelease];
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:.95 green:.96 blue:.97 alpha:1];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor colorWithRed:.89 green:.9 blue:91 alpha:1];
            [cell.contentView addSubview:line];
            [line release];
            line.tag = 101;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:100];
        NSArray *titles = [@"预订列表,销售状况,销售词汇,营收报表,销售报表" componentsSeparatedByString:@","];
        lbl.text = [titles objectAtIndex:indexPath.row];
        
        UIImageView *line = (UIImageView *)[cell.contentView viewWithTag:101];
        line.frame = CGRectMake(0, 59, tvLeft.frame.size.width, 1);
        
    }else{
        NSArray *identifiers = [NSArray arrayWithObjects:@"RightCellResv0",@"RightCellResv1",@"RightCellResv2",@"RightCellResv3",@"RightCellResv4", nil];\
        NSString *identifier = [identifiers objectAtIndex:listType];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSArray *ary = nil;
        if (!cell){
            switch (listType) {
                case BSDemoListResv:
                    cell = [[[BSDemoResvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    break;
                case BSDemoListSales:
                    cell = [[[BSDemoSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    break;
                case BSDemoListSaleWord:
                    cell = [[[BSDemoSalesWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
                    break;
                case BSDemoListIncomeChart:
                case BSDemoListSalesChart:
                    cell = [[[BSDemoChartCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                    break;
                default:
                    break;
            }
        }
        switch (listType) {
            case BSDemoListResv:
                ary = aryResult.count>0?aryResult:[[dicInfo objectForKey:@"ResvList"] objectForKey:@"Resv"];
                [(BSDemoResvCell *)cell setDelegate:self];
                break;
            case BSDemoListSales:
                ary = [[dicInfo objectForKey:@"ItemList"] objectForKey:@"foods"];
                break;
            case BSDemoListSaleWord:
                ary = aryResult.count>0?aryResult:[dicInfo objectForKey:@"MemoList"];
                break;
            case BSDemoListIncomeChart:
                ary = [[[dicInfo objectForKey:@"Reports"] objectAtIndex:0] objectForKey:@"Lists"];
                break;
            case BSDemoListSalesChart:
                ary = [[[dicInfo objectForKey:@"Reports"] objectAtIndex:1] objectForKey:@"Lists"];
                break;
                break;
            default:
                break;
        }
        
        if (listType==BSDemoListIncomeChart || listType==BSDemoListSalesChart){
            NSString *path = [[NSBundle mainBundle] pathForResource:@"CVPieChart.plist" ofType:nil];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            NSArray *ary = [dict objectForKey:@"colors"];
            
            NSMutableArray *colors = [NSMutableArray array];
            
            for (int i=0;i<[ary count];i++){
                NSArray *ar = [[ary objectAtIndex:i] componentsSeparatedByString:@","];
                NSString *sr = [ar objectAtIndex:0];
                NSString *sg = [ar objectAtIndex:1];
                NSString *sb = [ar objectAtIndex:2];
                NSString *sa = [ar objectAtIndex:3];
                
                [colors addObject:[UIColor colorWithRed:[sr floatValue] green:[sg floatValue] blue:[sb floatValue] alpha:[sa floatValue]]];
            }
            
            cell.contentView.backgroundColor = [colors objectAtIndex:indexPath.row];
        }else
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        
        [(BSDemoResvCell *)cell setDicInfo:[ary objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (listType==BSDemoListIncomeChart || listType==BSDemoListSalesChart){
        if (!vChart){
            vChart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tvRight.frame.size.width, 210)];
        }
        for (UIView *v in vChart.subviews){
            [v removeFromSuperview];
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CVPieChart.plist" ofType:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *ary = [dict objectForKey:@"colors"];
        
        NSMutableArray *colors = [NSMutableArray array];
        
        for (int i=0;i<[ary count];i++){
            NSArray *ar = [[ary objectAtIndex:i] componentsSeparatedByString:@","];
            NSString *sr = [ar objectAtIndex:0];
            NSString *sg = [ar objectAtIndex:1];
            NSString *sb = [ar objectAtIndex:2];
            NSString *sa = [ar objectAtIndex:3];
            
            [colors addObject:[UIColor colorWithRed:[sr floatValue] green:[sg floatValue] blue:[sb floatValue] alpha:[sa floatValue]]];
        }
        
        
        NSArray *arydatas = [[[dicInfo objectForKey:@"Reports"] objectAtIndex:listType==BSDemoListIncomeChart?0:1] objectForKey:@"Lists"];
        SWPieChart *pieChart = [[SWPieChart alloc] initWithFrame:CGRectMake(34, 50, 400, 400) colors:colors values:arydatas];
//        pieChart.delegate = self;
        [vChart addSubview:pieChart];
        
        return vChart;
    }else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (listType==BSDemoListIncomeChart || listType==BSDemoListSalesChart){
        return 500;
    }else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==tvLeft)
        return 5;
    
    NSArray *ary = nil;
    switch (listType) {
        case BSDemoListResv:
            ary = aryResult.count>0?aryResult:[[dicInfo objectForKey:@"ResvList"] objectForKey:@"Resv"];
            break;
        case BSDemoListSales:
            ary = [[dicInfo objectForKey:@"ItemList"] objectForKey:@"foods"];
            break;
        case BSDemoListSaleWord:
            ary = aryResult.count>0?aryResult:[dicInfo objectForKey:@"MemoList"];
            break;
        case BSDemoListIncomeChart:
            ary = [[[dicInfo objectForKey:@"Reports"] objectAtIndex:0] objectForKey:@"Lists"];
            break;
        case BSDemoListSalesChart:
            ary = [[[dicInfo objectForKey:@"Reports"] objectAtIndex:1] objectForKey:@"Lists"];
            break;
        default:
            break;
    }
    
    return ary.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tvLeft)
        return 60;
    else
        return [self heightForCell:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tvLeft==tableView){
        listType = indexPath.row;
        
        if (BSDemoListResv==listType || BSDemoListSaleWord==listType){
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            vcRight.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchBar] autorelease];
            searchBar.delegate = self;
            [aryResult removeAllObjects];
        }else
            vcRight.navigationItem.rightBarButtonItem = nil;
        
        [tvRight reloadData];
        
        NSArray *titles = [@"预订列表,销售状况,销售词汇,营收报表,销售报表" componentsSeparatedByString:@","];
        vcRight.navigationItem.title = [titles objectAtIndex:indexPath.row];
    }
}


@end
