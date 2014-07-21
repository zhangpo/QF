//
//  BSDemoChartCell.m
//  BookSystem
//
//  Created by Stan Wu on 12-10-12.
//
//

#import "BSDemoChartCell.h"

@implementation BSDemoChartCell
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
    }
    return self;
}

- (void)showInfo:(NSDictionary *)info{
    self.textLabel.text = [info objectForKey:@"Nam"];
    self.detailTextLabel.text = [info objectForKey:@"Val"];
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
