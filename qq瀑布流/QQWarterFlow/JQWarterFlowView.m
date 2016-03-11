//
//  JQWarterFlowView.m
//  qq瀑布流
//
//  Created by tang on 16/1/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "JQWarterFlowView.h"
#import "JQWarterFlowCell.h"
#define topDefault 15
#define buttomDefault 15
#define leftDefault 15
#define rightDefault 15
#define lineMarginDefault 15
#define clomeMarginDefault 15

#define clomeDefault 3
#define itemHight 44.0
//JQWaterflowViewMarginTop,
//JQWaterflowViewMarginButtom,
//JQWaterflowViewMarginLeft,
//JQWaterflowViewMarginRight,
//JQWaterflowViewMarginLine,
//JQWaterflowViewMarginClome
@interface JQWarterFlowView (){
    NSInteger _numberItem;
    NSInteger _numberClome;
}
@property (nonatomic, strong)NSMutableArray *itemFrameS;
@property (nonatomic, strong)NSMutableDictionary *clomeHights;
@property (nonatomic, strong)NSMutableDictionary *showedItemS;
@property (nonatomic, strong)NSMutableSet *reusablePond;//重用池
@end
@implementation JQWarterFlowView
CGFloat waterflowViewMarginTop;
CGFloat waterflowViewMarginButtom;
CGFloat waterflowViewMarginLeft;
CGFloat waterflowViewMarginRight;
CGFloat waterflowViewMarginline;
CGFloat waterflowViewMarginClome;
//init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置默认的间距
        [self setwaterflowViewMarginEdge:JQWaterflowViewMarginEdgeSetsMake(topDefault, buttomDefault, leftDefault, rightDefault)];
        [self setwaterflowViewMarginItemEdages:JQWaterflowViewMarginItemEdagesMake(lineMarginDefault, clomeMarginDefault)];
        
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = YES;
        
    }
    return self;
}
#pragma mark JQWarterFlowView方法
- (void)setwaterflowViewMarginEdge:(JQWaterflowViewMarginEdgeSets)edgeSet{
    waterflowViewMarginTop = edgeSet.top;
    waterflowViewMarginLeft = edgeSet.left;
    waterflowViewMarginRight = edgeSet.right;
    waterflowViewMarginButtom = edgeSet.buttom;
}

- (void)setwaterflowViewMarginItemEdages:(JQWaterflowViewMarginItemEdages)itemEdages{
    waterflowViewMarginline = itemEdages.line;
    waterflowViewMarginClome = itemEdages.clome;
}

- (void)reloadDate{
    [self.showedItemS.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];//***********记住&&&&&&&&&&&&&&&&&&
    [self.showedItemS removeAllObjects];
    [self.itemFrameS removeAllObjects];
    [self.reusablePond removeAllObjects];
    _numberItem = [self.dataSource numberItemwarterFlowView:self];
    _numberClome = [self numberClomeOfwarterflow];
    
    CGFloat top = waterflowViewMarginTop;
    CGFloat buttom =waterflowViewMarginButtom;
    CGFloat left = waterflowViewMarginLeft;
    CGFloat right = waterflowViewMarginRight;
    CGFloat line = waterflowViewMarginline;
    CGFloat clome = waterflowViewMarginClome;
    //item的宽度
    CGFloat itemWith = (self.frame.size.width - left - right + line) / _numberClome - line;
    CGFloat clomeHights[_numberClome];
    for (int i; i < _numberClome; i++) {
        clomeHights[i] = top;
    }
//    CGFloat maxY = top;
//    NSInteger minitClome = 0;
//    while循环
    NSInteger itemIndex = 0;
    while (itemIndex < _numberItem) {
        NSInteger minitag = 0;
        for (int i = 0; i < _numberClome - 1; i++) {
            if(clomeHights[i] > clomeHights[i + 1]){
                minitag = i + 1;
            };
        }
        CGFloat hightForItem = [self itemHighForIndex:itemIndex];
        CGRect frame = CGRectMake(left + minitag * (itemWith + clome), clomeHights[minitag], itemWith, hightForItem);
        NSValue *framevallue = [NSValue valueWithCGRect:frame];
        [self.itemFrameS addObject:framevallue];
        clomeHights[minitag] += hightForItem + line;
        itemIndex++;
    }
    //设置scroolView的contentSize
    CGFloat maxClome = clomeHights[0];
    for (int i = 0; i < _numberClome - 1; i++) {
        if(clomeHights[i] < clomeHights[i + 1]){
            maxClome = clomeHights[i + 1];
        };
    }
    maxClome += buttom;
    self.contentSize = CGSizeMake(0, maxClome);
}
- (JQWarterFlowCell *)itemForIndex:(NSInteger)index{
   return [self.dataSource warterFlowView:self cellForRowAtIndex:index];
}

- (JQWarterFlowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block JQWarterFlowCell *item = nil;
    [self.reusablePond enumerateObjectsUsingBlock:^(JQWarterFlowCell *pondItem, BOOL * _Nonnull stop) {
        if([pondItem.identifier isEqualToString:identifier]){
            item = pondItem;
        }
    }];
    if (item) {
        [self.reusablePond removeObject:item];
    }
    return item;
    
}
#pragma mark --
- (void)layoutSubviews{
    [super layoutSubviews];
    //get the index item
    NSUInteger numberItem = self.itemFrameS.count;
    for (int i = 0; i < numberItem; i++) {
//       JQWarterFlowCell *item = [self.dataSource warterFlowView:self cellForRowAtIndex:numberItem];
        JQWarterFlowCell *item = self.showedItemS[@(i)];
        CGRect frame = [self.itemFrameS[i] CGRectValue];
        if([self isTheItemshowWithFrame:frame]){
            if (item == nil) {
                item = [self.dataSource warterFlowView:self cellForRowAtIndex:i];
                item.frame = frame;
                [self addSubview:item];
                self.showedItemS[@(i)] = item;//******这是一个奇特的方法＊＊key 可以是id
            }
        }else if(item != nil){
            [item removeFromSuperview];
            [self.showedItemS removeObjectForKey:@(i)];
            [self.reusablePond addObject:item];
        }
    }
}
- (BOOL)isTheItemshowWithFrame:(CGRect)frame{
    CGFloat topLimit = frame.origin.y + frame.size.height - self.contentOffset.y;
    CGFloat buttomLimit = frame.origin.y - self.contentOffset.y - self.frame.size.height;
    if (buttomLimit < 0 && topLimit > 0) {
        return YES;
    }
    return NO;
}
//事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.waterDelegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)] || touches.count > 1) return;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];//获得被触摸的坐标点
    /*
     便利字典的方法
     
     */
    __block NSNumber *selectIndex = nil;
    [self.showedItemS enumerateKeysAndObjectsUsingBlock:^(NSNumber *  _Nonnull key, JQWarterFlowCell *  _Nonnull item, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(item.frame, point)) {//判断某个点是否在某个frame的范围内
            selectIndex = key;
        }
    }];
    if (selectIndex) {
        [self.waterDelegate waterflowView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}
#pragma mark -- integer
- (NSInteger)numberClomeOfwarterflow{
    if ([self.dataSource respondsToSelector:@selector(numberClomnsForwarterFlowView:)]) {
        return [self.dataSource numberClomnsForwarterFlowView:self];
    }
    if (self.numberClomes) {
        return self.numberClomes;
    }
    return clomeDefault;
}
- (CGFloat)itemHighForIndex :(NSInteger)index{
    if (self.waterDelegate != nil && [self.waterDelegate respondsToSelector:@selector(waterFlowView:heightForItemRowAtIndex:)]) {
        return [self.waterDelegate waterFlowView:self heightForItemRowAtIndex:index];
    }else return itemHight;
    
}
#pragma mark --laze
- (NSMutableArray *)itemFrameS{
    if (!_itemFrameS) {
        self.itemFrameS = [@[] mutableCopy];
    }
    return _itemFrameS;
}
- (NSMutableDictionary *)clomeHights{
    if (!_clomeHights) {
        self.clomeHights = [@{} mutableCopy];
    }
    return _clomeHights;
}
- (NSMutableDictionary *)showedItemS{
    if (!_showedItemS) {
        self.showedItemS = [@{} mutableCopy];
    }
    return _showedItemS;
}
- (NSMutableSet *)reusablePond{
    if (!_reusablePond) {
        self.reusablePond = [NSMutableSet set];
    }
    return _reusablePond;
}
@end
