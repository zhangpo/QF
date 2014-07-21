//
//  BSDemoResvCell.m
//  BookSystem
//
//  Created by Stan Wu on 12-10-11.
//
//

#import "BSDemoResvCell.h"

@implementation BSDemoResvCell
@synthesize bShowDetail,bBeginEdit,dicInfo,delegate;

- (void)dealloc{
    self.dicInfo = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        vBasic = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768-300, 130)];
        [self.contentView addSubview:vBasic];
        [vBasic release];
        
        vDetail = [[UIView alloc] initWithFrame:CGRectMake(0, -225, 768-300, 225)];
        [self.contentView addSubview:vDetail];
        [vDetail release];
        
        UIFont *font = [UIFont systemFontOfSize:15];
        
        lblFirm = [UILabel createLabelWithFrame:CGRectMake(12, 12, 400, 16) font:font];
        lblTele = [UILabel createLabelWithFrame:CGRectMake(12, 37, 200, 16) font:font];
        lblNam = [UILabel createLabelWithFrame:CGRectMake(225, 37, 200, 16) font:font];
        lblTim = [UILabel createLabelWithFrame:CGRectMake(12, 62, 200, 16) font:font];
        lblVIP = [UILabel createLabelWithFrame:CGRectMake(225, 62, 200, 16) font:font];
        imgvVIP = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fullstar.png"]] autorelease];

        btnShowMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnShowMore.frame = CGRectMake(17, 87, 115, 36);
        [btnShowMore setTitle:@"显示更多" forState:UIControlStateNormal];
        [btnShowMore addTarget:self action:@selector(showmoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnEdit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnEdit.frame = CGRectMake(200, 87, 115, 36);
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [btnEdit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [vBasic addSubview:lblFirm];
        [vBasic addSubview:lblTele];
        [vBasic addSubview:lblNam];
        [vBasic addSubview:lblTim];
        [vBasic addSubview:lblVIP];
        [vBasic addSubview:imgvVIP];
        [vBasic addSubview:btnShowMore];
        [vBasic addSubview:btnEdit];
        
        
        lblSub = [UILabel createLabelWithFrame:CGRectMake(12, 12, 400, 16) font:font];
        lblMemo = [UILabel createLabelWithFrame:CGRectMake(12, 37, 200, 16) font:font];
        lblPax = [UILabel createLabelWithFrame:CGRectMake(12, 62, 200, 16) font:font];
        lblEmp = [UILabel createLabelWithFrame:CGRectMake(225, 62, 200, 16) font:font];
        lblTbl = [UILabel createLabelWithFrame:CGRectMake(12, 87, 200, 16) font:font];
        lblKouwei = [UILabel createLabelWithFrame:CGRectMake(12, 112, 50, 16) font:font];lblKouwei.text = @"口味:";
        lblXihao = [UILabel createLabelWithFrame:CGRectMake(12, 137, 50, 16) font:font];lblXihao.text = @"喜好:";
        lblChedan = [UILabel createLabelWithFrame:CGRectMake(12, 162, 50, 16) font:font];lblChedan.text = @"泊车号:";
        lblQita = [UILabel createLabelWithFrame:CGRectMake(12, 187, 50, 16) font:font];lblQita.text = @"其他:";
        tfKouwei = [[[UITextField alloc] initWithFrame:CGRectMake(65, 112, 200, 16)] autorelease];
        tfXihao = [[[UITextField alloc] initWithFrame:CGRectMake(65, 137, 200, 16)] autorelease];
        tfChedan = [[[UITextField alloc] initWithFrame:CGRectMake(65, 162, 200, 16)] autorelease];
        tfQita = [[[UITextField alloc] initWithFrame:CGRectMake(65, 187, 200, 16)] autorelease];
        
        [vDetail addSubview:lblSub];
        [vDetail addSubview:lblMemo];
        [vDetail addSubview:lblPax];
        [vDetail addSubview:lblEmp];
        [vDetail addSubview:lblTbl];
        [vDetail addSubview:lblKouwei];
        [vDetail addSubview:lblXihao];
        [vDetail addSubview:lblChedan];
        [vDetail addSubview:lblQita];
        [vDetail addSubview:tfKouwei];
        [vDetail addSubview:tfXihao];
        [vDetail addSubview:tfChedan];
        [vDetail addSubview:tfQita];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showInfo:(NSDictionary *)dic{
    lblFirm.text = [NSString stringWithFormat:@"单位: %@",[dic objectForKey:@"Firm"]];
    lblTele.text = [NSString stringWithFormat:@"电话: %@",[dic objectForKey:@"Tele"]];
    lblNam.text = [NSString stringWithFormat:@"预订人: %@",[dic objectForKey:@"Nam"]];
    lblTim.text = [NSString stringWithFormat:@"到达时间: %@",[dic objectForKey:@"Tim"]];
    lblVIP.text = [[dic objectForKey:@"Vip"] boolValue]?@"VIP: ":nil;
    imgvVIP.center = CGPointMake(285, 70);
    imgvVIP.hidden = ![[dic objectForKey:@"Vip"] boolValue];
    
    lblSub.text = [NSString stringWithFormat:@"主题: %@",[dic objectForKey:@"Sub"]];
    lblMemo.text = [NSString stringWithFormat:@"备注: %@",[dic objectForKey:@"Memo"]];
    lblPax.text = [NSString stringWithFormat:@"人数: %@",[dic objectForKey:@"Pax"]];
    lblEmp.text = [NSString stringWithFormat:@"预订员: %@",[dic objectForKey:@"Emp"]];
    lblTbl.text = [NSString stringWithFormat:@"包间号: %@",[dic objectForKey:@"Tbl"]];
    tfKouwei.text = [dic objectForKey:@"Kouwei"];
    tfXihao.text = [dic objectForKey:@"Xihao"];
    tfChedan.text = [dic objectForKey:@"Chedan"];
    tfQita.text = [dic objectForKey:@"Qita"];
    
    
    for (UILabel *lbl in vBasic.subviews){
        if ([lbl isKindOfClass:[UILabel class]]){
            lbl.text = [lbl.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        }
    }
    for (UILabel *lbl in vDetail.subviews){
        if ([lbl isKindOfClass:[UILabel class]]){
            lbl.text = [lbl.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        }
    }
    for (UITextField *tf in vDetail.subviews){
        if ([tf isKindOfClass:[UITextField class]]){
            tf.font = [UIFont systemFontOfSize:12];
            tf.text = [tf.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        }
    }
    
    [self refreshLayout];
}

- (void)refreshLayout{
    if (bShowDetail){
        vDetail.frame = CGRectMake(0, 0, vDetail.frame.size.width, vDetail.frame.size.height);
        vBasic.frame = CGRectMake(0, vDetail.frame.size.height, vBasic.frame.size.width, vBasic.frame.size.height);
    }else{
        vDetail.frame = CGRectMake(0, -vDetail.frame.size.height, vDetail.frame.size.width, vDetail.frame.size.height);
        vBasic.frame = CGRectMake(0, 0, vBasic.frame.size.width, vBasic.frame.size.height);
    }
    
    for (UITextField *tf in vDetail.subviews){
        if ([tf isKindOfClass:[UITextField class]]){
            tf.borderStyle = bBeginEdit?UITextBorderStyleRoundedRect:UITextBorderStyleNone;
            tf.userInteractionEnabled = bBeginEdit;
        }
    }
}

- (void)setDicInfo:(NSDictionary *)dic{
    if (dicInfo!=dic){
        [dicInfo release];
        dicInfo = [dic retain];
        
        [self showInfo:dicInfo];
    }else
        [self refreshLayout];
}

- (void)showmoreClicked:(UIButton *)btn{
    bShowDetail = !bShowDetail;
    if ([(NSObject *)delegate respondsToSelector:@selector(cellNeedsRefresh:)])
        [delegate cellNeedsRefresh:self];
}

- (void)editClicked:(UIButton *)btn{
    bBeginEdit = !bBeginEdit;
    if ([(NSObject *)delegate respondsToSelector:@selector(cellNeedsRefresh:)])
        [delegate cellNeedsRefresh:self];
}

@end
