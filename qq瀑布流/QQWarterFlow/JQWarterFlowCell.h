//
//  JQWarterFlowCell.h
//  qq瀑布流
//
//  Created by tang on 16/1/2.
//  Copyright © 2016年 汤鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQWarterFlowCell : UIView
@property(nonatomic, strong)NSString *identifier;
- (instancetype)initWithIdentifier :(NSString *)identifier;

@end
