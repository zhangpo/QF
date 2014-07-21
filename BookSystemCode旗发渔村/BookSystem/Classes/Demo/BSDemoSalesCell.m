//
//  BSDemoSalesCell.m
//  BookSystem
//
//  Created by Stan Wu on 12-10-12.
//
//

#import "BSDemoSalesCell.h"
#import "BSDataProvider.h"

@implementation BSDemoSalesCell
@synthesize dicInfo;

- (void)dealloc{
    self.dicInfo = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIFont *font = [UIFont systemFontOfSize:15];
        
        lblName = [UILabel createLabelWithFrame:CGRectMake(12, 12, 400, 16) font:font];
        lblUnit = [UILabel createLabelWithFrame:CGRectMake(12, 37, 200, 16) font:font];
        lblPrice = [UILabel createLabelWithFrame:CGRectMake(115, 37, 200, 16) font:font];
        lblPlan = [UILabel createLabelWithFrame:CGRectMake(12, 62, 200, 16) font:font];
        lblSold = [UILabel createLabelWithFrame:CGRectMake(225, 62, 200, 16) font:font];
        lblLeft = [UILabel createLabelWithFrame:CGRectMake(12, 87, 200, 16) font:font];
        lblLeftRatio = [UILabel createLabelWithFrame:CGRectMake(225, 87, 200, 16) font:font];
        
        lblSold.textColor = [UIColor greenColor];
        lblLeftRatio.textColor = [UIColor redColor];
        
        [self.contentView addSubview:lblName];
        [self.contentView addSubview:lblUnit];
        [self.contentView addSubview:lblPrice];
        [self.contentView addSubview:lblPlan];
        [self.contentView addSubview:lblSold];
        [self.contentView addSubview:lblLeft];
        [self.contentView addSubview:lblLeftRatio];
    }
    return self;
}

- (void)showInfo:(NSDictionary *)info{
    NSDictionary *foodInfo = [[BSDataProvider sharedInstance] getFoodByCode:[info objectForKey:@"Itcode"]];
    
    lblName.text = [NSString stringWithFormat:@"产品: %@",[foodInfo objectForKey:@"DES"]];
    lblUnit.text = [NSString stringWithFormat:@"产品: %@",[foodInfo objectForKey:@"UNIT"]];
    lblPrice.text = [NSString stringWithFormat:@"产品: %@",[foodInfo objectForKey:@"PRICE"]];
    lblPlan.text = [NSString stringWithFormat:@"预计销售: %d",[[info objectForKey:@"Cnt"] intValue]*2];
    lblSold.text = [NSString stringWithFormat:@"已销售: %d",[[info objectForKey:@"Cnt"] intValue]];
    lblLeft.text = [NSString stringWithFormat:@"剩余: %d",[[info objectForKey:@"Cnt"] intValue]];
    lblLeftRatio.text = [NSString stringWithFormat:@"剩余率: %.0f%%",.5*100];
}

- (void)setDicInfo:(NSDictionary *)dic{
    if (dicInfo!=dic){
        [dicInfo release];
        dicInfo = [dic retain];
    }
    
    [self showInfo:dic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
