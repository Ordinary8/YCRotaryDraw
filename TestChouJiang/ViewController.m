//
//  ViewController.m
//  TestChouJiang
//
//  Created by 袁灿 on 15/11/12.
//  Copyright © 2015年 yuancan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *strPrise;
}

@property (retain, nonatomic) UIView  *popView;
@property (retain, nonatomic) UILabel *labPrise;
@property (retain, nonatomic) UIButton *btn;
@property (retain, nonatomic) UIImageView *zhuanpan;

@end

@implementation ViewController
@synthesize btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景
    UIImageView *imgViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgViewBg.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:imgViewBg];
    
    //转盘
    _zhuanpan = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-280)/2,10, 280, 280)];
    _zhuanpan.image = [UIImage imageNamed:@"zhuanpan.png"];
    [self.view addSubview:_zhuanpan];
    
    //手指
    UIImageView *hander = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    hander.center = CGPointMake(_zhuanpan.center.x, _zhuanpan.center.y-30);
    hander.image = [UIImage imageNamed:@"hander.png"];
    [self.view addSubview:hander];
    
    //开始或停止按钮
    btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, self.view.frame.size.height-200, 200, 35)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
    _labPrise = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 200, 20)];
    _labPrise.textColor = [UIColor orangeColor];
    [self.view addSubview:_labPrise];
    
}

- (void)btnClick
{
    NSInteger angle;
    NSInteger randomNum = arc4random()%100;
    
    if (randomNum>=91 && randomNum<=99) {
        angle = 300;
        strPrise = @"一等奖";
    } else if (randomNum>=76 && randomNum<= 90) {
        angle = 60;
        strPrise = @"二等奖";
    } else if (randomNum >=51 && randomNum<=75) {
        angle = 180;
        strPrise = @"三等奖";
    } else {
        angle = 240;
        strPrise = @"没中奖";
    }
    
    [btn setTitle:@"抽奖中..." forState:UIControlStateNormal];
    _labPrise.text = [NSString stringWithFormat:@"中奖结果:%@",@"等待开奖结果"];
    btn.enabled = NO;
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle*M_PI/180 ];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_zhuanpan.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:2.0
                     animations:^{
                         
                         _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                         
                         _popView.backgroundColor = [UIColor clearColor];
                         _popView.alpha = 0.7;
                         
                         UIImageView *popImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, self.view.frame.size.width-200, self.view.frame.size.width-200)];
                         popImageView.image = [UIImage imageNamed:@"prise.png"];
                         [_popView addSubview:popImageView];
                         [self.view addSubview:_popView];
                        
                         _popView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         
                     }
                     completion:^(BOOL finished) {
                         [_popView removeFromSuperview];
                         _labPrise.text = [NSString stringWithFormat:@"中奖结果 : %@",strPrise];
                         [btn setTitle:@"开始抽奖" forState:UIControlStateNormal];
                         btn.enabled = YES;
                         
                     }];

}

////使用NSURLSessionDataTask请求数据
//- (void)loadData {
//
//    [_activity startAnimating];
//
//    // 创建Data Task
//    NSURL *url = [NSURL URLWithString:@"http://192.168.41.48/~jenkins/Json/lottery.php"];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:
//                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                          // 输出返回的状态码，请求成功的话为200
//                                          NSDictionary *jsondic;
//                                              jsondic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                                          NSLog(@"%@",jsondic);
//                                          
//                                          num = [[[jsondic objectForKey:@"result"] objectForKey:@"num"] integerValue];
//                                          strPrise = [[jsondic objectForKey:@"result"] objectForKey:@"info"];
//                                          [_activity stopAnimating];
//                                          [self startAnimation];
//                                          
//                                      }];
//    [dataTask resume];
//}


@end
