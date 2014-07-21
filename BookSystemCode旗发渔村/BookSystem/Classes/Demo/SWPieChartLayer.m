//
//  SWPieChartLayer.m
//  PieChart
//
//  Created by Wu Stan on 12-1-4.
//  Copyright (c) 2012年 CheersDigi. All rights reserved.
//

#import "SWPieChartLayer.h"
#import "CVPieUtil.h"
#import <mach/mach_time.h>
#import <sys/time.h>

@implementation SWPieChartLayer
@synthesize aryColors,aryValues,aryInfo;
@synthesize pieDelegate;
@synthesize radius;

-(uint64_t) getTickCount
{
	struct timeval now;
	gettimeofday(&now,NULL);
	return now.tv_usec/1000+now.tv_sec*1000;
	
	return mach_absolute_time()/1000000;
}



- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors values:(NSArray *)values{
    self = [super init];
    
    if (self) {
        // Initialization code
        self.frame = frame;
        radius = self.frame.size.width/2;
        self.aryValues = values;
        self.aryColors = colors;
        angle = 0;
        canShowLabel = YES;
        lastKick = 0;
        
        [self addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}




- (void)drawInContext:(CGContextRef)context{
    NSLog(@"Diaplay Invoked");
    
	if ( !aryColors || !aryValues )
	{
#ifdef DEBUG
		NSLogv(@"color array or share array is NULL", nil);
#endif
		return;
	}
    if ([aryColors count] < [aryValues count]) {
        return;
    }
	
	CGMutablePathRef path;
	
	for (int i = 0; i < [aryValues count] - 1; i++)
	{
        float startAngle = [[aryValues objectAtIndex:i] floatValue]*2*M_PI;
		float endAngle = [[aryValues objectAtIndex:i+1] floatValue]*2*M_PI;
        if (startAngle!=endAngle){
            path = CGPathCreateMutable();
            
            
            CGPoint poss0 = getPos(radius*180.0f/295.0f, startAngle);
            CGPoint poss1 = getPos(radius*180.0f/295.0f, endAngle);
            poss0 = CGPointMake(poss0.x+radius, poss0.y+radius);
            poss1 = CGPointMake(poss1.x+radius, poss1.y+radius);
            
            CGPoint pos1 = getPos(radius, startAngle);
            pos1 = CGPointMake(pos1.x+radius, pos1.y+radius);
            CGPathMoveToPoint(path,NULL,radius,radius);
            CGPathAddLineToPoint(path,NULL,pos1.x,pos1.y);
            CGPathAddArc(path,NULL,radius,radius,radius,startAngle,endAngle,NO);
            CGPathAddLineToPoint(path,NULL,radius,radius);
            /*
            CGPathMoveToPoint(path, NULL, poss0.x, poss0.y);
            CGPathAddLineToPoint(path, NULL, pos1.x, pos1.y);
            CGPathAddArc(path, NULL, radius, radius, radius, startAngle, endAngle, NO);
            CGPathAddLineToPoint(path, NULL, poss1.x, poss1.y);
            CGPathAddArc(path, NULL, radius, radius, radius*180.0f/295.0f, endAngle, startAngle, YES);
             */
            CGPathCloseSubpath(path);
            
            UIColor* fillColor = [aryColors objectAtIndex:i];
            CGContextSetFillColorWithColor(context, [fillColor CGColor]);
            CGContextAddPath(context, path);
            CGContextFillPath(context);
            CGPathRelease(path);
            
            NSLog(@"X:%f,Y:%f,Radius:%f",radius,radius,radius);
        }
	}
    
    float startAngle = [[aryValues lastObject] floatValue]*2*M_PI;
    float endAngle = [[aryValues objectAtIndex:0] floatValue]*2*M_PI;
    if (startAngle!=endAngle){
        path = CGPathCreateMutable();
        
        
        CGPoint pos1 = getPos(radius, startAngle);
        pos1 = CGPointMake(pos1.x+radius, pos1.y+radius);
        CGPoint poss0 = getPos(radius*180.0f/295.0f, startAngle);
        CGPoint poss1 = getPos(radius*180.0f/295.0f, endAngle);
        poss0 = CGPointMake(poss0.x+radius, poss0.y+radius);
        poss1 = CGPointMake(poss1.x+radius, poss1.y+radius);
        
        CGPathMoveToPoint(path,NULL,radius,radius);
        CGPathAddLineToPoint(path,NULL,pos1.x,pos1.y);
        CGPathAddArc(path,NULL,radius,radius,radius,startAngle,endAngle,NO);
        CGPathAddLineToPoint(path,NULL,radius,radius);
        
        /*
        CGPathMoveToPoint(path, NULL, poss0.x, poss0.y);
        CGPathAddLineToPoint(path, NULL, pos1.x, pos1.y);
        CGPathAddArc(path, NULL, radius, radius, radius, startAngle, endAngle, NO);
        CGPathAddLineToPoint(path, NULL, poss1.x, poss1.y);
        CGPathAddArc(path, NULL, radius, radius, radius*180.0f/295.0f, endAngle, startAngle, YES);
        CGPathCloseSubpath(path);
         */
        
        UIColor* fillColor = [aryColors lastObject];
        CGContextSetFillColorWithColor(context, [fillColor CGColor]);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGPathRelease(path);
    }
    
    
    
    [self adjustAngle];
    /*
    CGPoint ptc = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    float a[] = {0,1};
    float c[] = {0,0,0,0.1,0,0,0,0.2};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, c, a, 2);
    
    

 //   CGContextDrawRadialGradient(context, gradient, ptc, 2, ptc, self.frame.size.width/2, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient);
     */
}

- (void)deceleratationEnded{
    [self showLabels];
    [self adjustAngle];
}

- (void)inertiaRotate:(float)angleToRotate{
    NSLog(@"Angle:%f",angle);
    NSLog(@"My Transform:%@",[self valueForKeyPath:@"transfrom.rotation"]);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSLog(@"Angle:%f",angle);
         NSLog(@"My Transform:%@",[self valueForKeyPath:@"transfrom"]);
        angle += angleToRotate;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            [self showLabels];
            [self adjustAngle];
        }];
        self.transform = CATransform3DMakeRotation(angle, 0, 0, -1);
        [CATransaction commit];
        
        
    }];
    [CATransaction setDisableActions:YES];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = YES;
    animation.autoreverses = NO;
    
    animation.duration = 1.0f;
    

    animation.speed = 1.0f;
    
    animation.fromValue = [NSNumber numberWithDouble:2*M_PI-angle];
    animation.toValue = [NSNumber numberWithDouble:2*M_PI-(angle+angleToRotate)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self addAnimation:animation forKey:@"transform"];
    
    
    [CATransaction commit];
}

- (void)rotate:(float)angleToRotate animated:(BOOL)animated{
    if (!animated){
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    }
    
	angle += angleToRotate;
    	self.transform = CATransform3DMakeRotation(angle, 0, 0, -1);
  //  self.transform = CATransform3DRotate(self.transform, angleToRotate, 0, 0, -1);
    
    
    
    
	int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		lbl.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);//CATransform3DRotate(layer.transform, angle, 0, 0, 1);
	}
    
    
	float currentStandard = angle + kIndicatorAngle;
	
	while (currentStandard > 2*M_PI)
	{
		currentStandard -= 2*M_PI;
	}
	while ( currentStandard < 0)
	{
		currentStandard += 2*M_PI;
	}
	
	for (int i = 0; i < [aryValues count]; ++i)
	{
        
		float endAngle;
        if (i<[aryValues count]-1)
            endAngle = [[aryValues objectAtIndex:i+1] floatValue]*2*M_PI;
        else
            endAngle= 2*M_PI;
		if ( endAngle > currentStandard )
		{
            if (i!=currentRegion){
                currentRegion = i;
                
                [NSThread detachNewThreadSelector:@selector(playTick) toTarget:self withObject:nil];
            }
            
			break;
		}
	}
    
    if (!animated){
        [CATransaction commit];
    }

}

- (void)rotate:(float)angleToRotate{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    //foo
    
    
    
	angle += angleToRotate;
	self.transform = CATransform3DMakeRotation(angle, 0, 0, -1);
//      self.transform = CATransform3DRotate(self.transform, angleToRotate, 0, 0, -1);
    

    

	int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		lbl.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 11);//CATransform3DRotate(layer.transform, angle, 0, 0, 1);
	}
    

	float currentStandard = angle + kIndicatorAngle;
	
	while (currentStandard > 2*M_PI)
	{
		currentStandard -= 2*M_PI;
	}
	while ( currentStandard < 0)
	{
		currentStandard += 2*M_PI;
	}
	
	for (int i = 0; i < [aryValues count]; ++i)
	{

		float endAngle;
        if (i<[aryValues count]-1)
            endAngle = [[aryValues objectAtIndex:i+1] floatValue]*2*M_PI;
        else
            endAngle= 2*M_PI;
		if ( endAngle > currentStandard )
		{
            if (i!=currentRegion){
                currentRegion = i;
                
                [NSThread detachNewThreadSelector:@selector(playTick) toTarget:self withObject:nil];
            }

			break;
		}
	}
    
    [CATransaction commit];
}

- (void)setFrame:(CGRect)frame{
    radius = (int)(frame.size.width/2);
    [self performSelector:@selector(resetInfoLayers)];
    
    [super setFrame:frame];
}

- (void)resetInfoLayers{
    for (int i = 0; i < [aryInfo count]; i++){        
        //		layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);
        UILabel *lbl = [aryInfo objectAtIndex:i];
		CGFloat curCenterDegree;
        if (i<[aryValues count]-1)
            curCenterDegree = ([[aryValues objectAtIndex:i] floatValue]+[[aryValues objectAtIndex:i+1] floatValue])/2*2*M_PI;
        else
            curCenterDegree = ([[aryValues objectAtIndex:i] floatValue]+1)/2*2*M_PI;
        
		CGPoint pos = getPos(radius*0.75f, curCenterDegree);
        pos = CGPointMake((int)(pos.x+radius), (int)(pos.y+radius));
		lbl.layer.position = pos;

	}
}


- (void)addInfoLayers{
    NSMutableArray *ary = [NSMutableArray array];
	for (int i = 0; i < [aryValues count]; i++)
	{
        
		
		NSString* text = nil;
            if (i<[aryValues count]-1)
                text = [NSString stringWithFormat:@"%.1f%%", ([[aryValues objectAtIndex:i+1] floatValue]-[[aryValues objectAtIndex:i] floatValue])*100];
            else
                text = [NSString stringWithFormat:@"%.1f%%", (1-[[aryValues objectAtIndex:i] floatValue])*100];
		UIFont*	  font = [UIFont systemFontOfSize:12];
		UIColor*  color = [UIColor whiteColor];
		CGSize    size = [text sizeWithFont:font];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        lbl.layer.anchorPoint = CGPointMake(0.5f,0.5f);
        lbl.shadowColor = [UIColor blackColor];
        lbl.shadowOffset = CGSizeMake(0, 2);
        lbl.textColor = color;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = font;
        lbl.text = text;

//		layer.transform = CATransform3DRotate(layer.transform, M_PI, 0, 0, 1);

		CGFloat curCenterDegree;
        if (i<[aryValues count]-1)
            curCenterDegree = ([[aryValues objectAtIndex:i] floatValue]+[[aryValues objectAtIndex:i+1] floatValue])/2*2*M_PI;
        else
            curCenterDegree = ([[aryValues objectAtIndex:i] floatValue]+1)/2*2*M_PI;
		CGPoint pos = getPos(radius*0.8f, curCenterDegree);
        pos = CGPointMake((int)(pos.x+radius), (int)(pos.y+radius));
		lbl.center = pos;
		[self addSublayer:lbl.layer];
		[ary addObject:lbl];

	}
    
    self.aryInfo = [NSArray arrayWithArray:ary];
    
    int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		if ((i==currentRegion || [lbl.text floatValue]>15) && canShowLabel)
            lbl.hidden = NO;
        else
            lbl.hidden = YES;
        
	}
    
}



- (void)adjustAngle
{
	float angleToRotate = 0.0;
	float currentStandard = angle + kIndicatorAngle;
	
	while (currentStandard > 2*M_PI)
	{
		currentStandard -= 2*M_PI;
	}
	while ( currentStandard < 0)
	{
		currentStandard += 2*M_PI;
	}
	

	for (int i = 0; i < [aryValues count]; ++i)
	{
        float startAngle = [[aryValues objectAtIndex:i] floatValue]*2*M_PI;
		float endAngle;
        if (i<[aryValues count]-1)
            endAngle = [[aryValues objectAtIndex:i+1] floatValue]*2*M_PI;
        else
            endAngle = 2*M_PI;
		if ( endAngle > currentStandard )
		{

            currentRegion = i;
			
			angleToRotate = (startAngle + endAngle)/2 - currentStandard;

			break;
		}
	}
    
	[self rotate:angleToRotate animated:YES];
	
	[self didRunIntoRegion:currentRegion];
    int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		if ((i==currentRegion || [lbl.text floatValue]>15) && canShowLabel)
            lbl.hidden = NO;
        else
            lbl.hidden = YES;
	}
}

- (void)playTick{
    @autoreleasepool {
        uint64_t currentTick = [self getTickCount];
        uint64_t delta = currentTick-lastKick;
        
        float seconds = delta/(double)CLOCKS_PER_SEC;
        
        
        //    NSLog(@"Prev:%lld,Now:%f",lastKick,seconds);
        if (1 || seconds>0.025f){
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Tock.aiff" ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            

            
            lastKick = currentTick;
        }
    }
}



- (void)didRunIntoRegion:(NSUInteger)index{
    [pieDelegate didRunIntoRegion:index];
}

- (void)showLabels{
    canShowLabel = YES;
    int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		if ((i==currentRegion || [lbl.text floatValue]>15) && canShowLabel)
            lbl.hidden = NO;
        else
            lbl.hidden = YES;
	}
}

- (void)hideLabels{
    canShowLabel = NO;
    int totalCount = [aryInfo count];
	for ( int i=0;i<totalCount;i++ )
	{
		UILabel *lbl = [aryInfo objectAtIndex:i];
		if ((i==currentRegion || [lbl.text floatValue]>15) && canShowLabel)
            lbl.hidden = NO;
        else
            lbl.hidden = YES;
	}
}


- (NSUInteger)currentRegion{
    return currentRegion;
}


#pragma mark -
#pragma mark Key Value Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
 
}

@end
