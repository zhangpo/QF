//
//  BSDemoSalesWordCell.m
//  BookSystem
//
//  Created by Stan Wu on 12-10-12.
//
//

#import "BSDemoSalesWordCell.h"

@implementation BSDemoSalesWordCell
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
        tvDetail = [[[UITextView alloc] initWithFrame:CGRectMake(12, 37, 440, 75)] autorelease];
        tvDetail.font = font;
        tvDetail.editable = NO;
        
        [self.contentView addSubview:lblName];
        [self.contentView addSubview:tvDetail];
    }
    return self;
}

- (void)showInfo:(NSDictionary *)info{
    lblName.text = [info objectForKey:@"Nam"];
    tvDetail.text = [info objectForKey:@"Memo"];
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
