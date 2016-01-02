//
//  JQWarterFlowCell.m
//  qq瀑布流
//
//  Created by tang on 16/1/2.
//  Copyright © 2016年 汤鹏. All rights reserved.
//

#import "JQWarterFlowCell.h"

@implementation JQWarterFlowCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithIdentifier:(NSString *)identifier{
    self = [[JQWarterFlowCell alloc]init];
    self.identifier = identifier;
    return self;
}

@end
