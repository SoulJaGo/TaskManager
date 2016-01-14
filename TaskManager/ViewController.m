//
//  ViewController.m
//  TaskManager
//
//  Created by SoulJa on 16/1/13.
//  Copyright © 2016年 SoulJa. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"

@interface ViewController () <iCarouselDataSource,iCarouselDelegate>
@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,assign) CGSize taskSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat taskWidth = [UIScreen mainScreen].bounds.size.width * 5.0 / 7.0;
    self.taskSize = CGSizeMake(taskWidth, taskWidth * 16.0 / 9.0);
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.carousel];
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    [self.carousel setType:iCarouselTypeCustom];
    [self.carousel setBounceDistance:0.1];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 7;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *taskView = view;
    if (!taskView) {
        taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.taskSize.width, self.taskSize.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:taskView.bounds];
        [taskView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)index];
        [imageView setImage:[UIImage imageNamed:indexStr]];
        UILabel *label = [[UILabel alloc] initWithFrame:taskView.frame];
        [label setText:[@(index) stringValue]];
        [label setFont:[UIFont systemFontOfSize:50]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [taskView addSubview:label];
    }
    return taskView;
}

// 计算缩放
- (CGFloat)calcScaleWithOffset:(CGFloat)offset {
    return offset * 0.02f + 1.0f;
}

//计算位移
- (CGFloat)calcTranslationWithOffset:(CGFloat)offset {
    CGFloat z = 5.0f / 4.0f;
    CGFloat a = 5.0f / 8.0f;
    if (offset >= z/a) {
        return 2.0f;
    } else {
        return  1/ (z - a * offset) - 1 / z;
    }
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calcTranslationWithOffset:offset];
    return CATransform3DScale(CATransform3DTranslate(transform, self.taskSize.width * translation, 0, 0), scale, scale, 1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
