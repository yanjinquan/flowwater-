//
//  JQWarterFlowView.h
//  qq瀑布流
//
//  Created by tang on 16/1/2.
//  Copyright © 2016年 汤鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JQWaterflowViewMarginType){
    JQWaterflowViewMarginTop,
    JQWaterflowViewMarginButtom,
    JQWaterflowViewMarginLeft,
    JQWaterflowViewMarginRight,
    JQWaterflowViewMarginLine,
    JQWaterflowViewMarginClome
};
/*
 边界设置
 */
typedef struct JQWaterflowViewMarginEdgeSets{
    CGFloat top, buttom, left, right;
} JQWaterflowViewMarginEdgeSets;
CG_INLINE JQWaterflowViewMarginEdgeSets
JQWaterflowViewMarginEdgeSetsMake(CGFloat top, CGFloat buttom, CGFloat left, CGFloat right){
    JQWaterflowViewMarginEdgeSets set;
    set.top = top;
    set.buttom = buttom;
    set.left = left;
    set.right = right;
    return set;
}
typedef struct JQWaterflowViewMarginItemEdages{
    CGFloat line, clome;
} JQWaterflowViewMarginItemEdages;
CG_INLINE JQWaterflowViewMarginItemEdages
JQWaterflowViewMarginItemEdagesMake(CGFloat line, CGFloat clome){
    JQWaterflowViewMarginItemEdages set;
    set.clome = clome;
    set.line = line;
    return set;
}
@class JQWarterFlowCell;
@protocol JQWarterFlowViewDataSource;
@protocol JQWarterFlowViewDelegate;

/*
 JQWarterFlowView
 */
@interface JQWarterFlowView : UIScrollView
@property(nonatomic, weak)id<JQWarterFlowViewDataSource> dataSource;//数据源
@property(nonatomic, weak)id<JQWarterFlowViewDelegate> waterDelegate;//代理（？？为何不能重名 ？？）
- (void)setwaterflowViewMarginEdge :(JQWaterflowViewMarginEdgeSets)edgeSet;//设置整体的边距
- (void)setwaterflowViewMarginItemEdages:(JQWaterflowViewMarginItemEdages)itemEdages;//设置行和列的边距nullable
- (void)reloadDate;
- (JQWarterFlowCell *)itemForIndex:(NSInteger)index;
- (JQWarterFlowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
/*
 JQWarterFlowViewDataSource
 */
@protocol JQWarterFlowViewDataSource <NSObject>
@required
- (NSInteger)numberItemwarterFlowView :(JQWarterFlowView *)warterFlowView;

- (__kindof JQWarterFlowCell *)warterFlowView:(JQWarterFlowView *)warterFlowView cellForRowAtIndex:(NSInteger)index;

@optional
- (NSInteger)numberClomnsForwarterFlowView:(JQWarterFlowView *)warterFlowView;
@end

/*
 JQWarterFlowViewDelegate
 */

@protocol JQWarterFlowViewDelegate <NSObject, UIScrollViewDelegate>
@optional
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);

// Variable height support

- (CGFloat)waterFlowView:(JQWarterFlowView *)warterFlowView heightForItemRowAtIndex :(NSInteger)index;
- (void)waterflowView:(JQWarterFlowView *)waterflowView didSelectAtIndex:(NSUInteger)index;
/**
 *  返回间距
 */
- (CGFloat)waterflowView:(JQWarterFlowView *)waterflowView marginForType:(JQWaterflowViewMarginType)type;



@end