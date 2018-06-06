//
//  ViewController.m
//  qq瀑布流
//
//  Created by tang on 16/1/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ViewController.h"
#import "JQWarterFlowView.h"
#import "JQWarterFlowCell.h"
@interface ViewController ()<JQWarterFlowViewDataSource, JQWarterFlowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JQWarterFlowView *warterFlowView = [[JQWarterFlowView alloc]initWithFrame:self.view.frame];
    warterFlowView.waterDelegate = self;
    warterFlowView.dataSource = self;
    
    [self.view addSubview:warterFlowView];
    [warterFlowView reloadDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberItemwarterFlowView:(JQWarterFlowView *)warterFlowView{
    NSLog(@"%s", __FUNCTION__);
    return 100;
}

- (JQWarterFlowCell *)warterFlowView:(JQWarterFlowView *)warterFlowView cellForRowAtIndex:(NSInteger)index{
    JQWarterFlowCell *cell = [warterFlowView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell) {
        cell = [[JQWarterFlowCell alloc]initWithIdentifier:@"identifier"];
        NSLog(@"%@---%@-----%ld", cell , cell.identifier, index);
    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    return cell;
}
- (CGFloat)waterFlowView:(JQWarterFlowView *)warterFlowView heightForItemRowAtIndex:(NSInteger)index{
    NSLog(@"%s", __FUNCTION__);
    return arc4random_uniform(20) * 3.0 + 40;
}
- (void)waterflowView:(JQWarterFlowView *)waterflowView didSelectAtIndex:(NSUInteger)index{
    NSLog(@"index = %ld, %s", index, __FUNCTION__);
}
@end
