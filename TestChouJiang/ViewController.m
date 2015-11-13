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
    float angle;
    float angleTotal;

    NSInteger num;
}

@property (retain, nonatomic) UIImageView *zhuanpan;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    angle = 10;
    
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
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, self.view.frame.size.height-200, 200, 35)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton *)btn
{
    switch ([btn tag]) {
        case 0:
        {
            [btn setTitle:@"结束" forState:UIControlStateNormal];
            [btn setTag:1];
            
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 1.0f;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = 100;
            [_zhuanpan.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            
            [self loadData];

            [self startAnimation];

        }
            break;
            
        case 1:
        {
            [btn setTitle:@"开始" forState:UIControlStateNormal];
            [btn setTag:0];
            
            [_zhuanpan.layer removeAllAnimations];
        }
            break;
            
        default:
            break;
    }
}


//使用NSURLSessionDataTask请求数据
- (void)loadData {
    
    // 创建Data Task
    NSURL *url = [NSURL URLWithString:@"http://192.168.41.48/~jenkins/Json/lottery.php"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // 输出返回的状态码，请求成功的话为200
                                          NSDictionary *jsondic;
                                              jsondic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                          NSLog(@"%@",jsondic);
                                          
                                          num = [[[jsondic objectForKey:@"result"] objectForKey:@"num"] integerValue];

                                          [self startAnimation];
                                          
                                      }];
    [dataTask resume];
}

//旋转
-(void)startAnimation
{
    
    if (num>=91 && num<=99) {
        angleTotal = 300;
    } else if (num>=76 && num<= 90) {
        angleTotal = 240;
    } else if (num >=51 && num<=75) {
        angleTotal = 60;
    } else {
        angleTotal = 270;
    }
    
    angleTotal = angleTotal+360;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _zhuanpan.transform = CGAffineTransformMakeRotation(angleTotal*(M_PI/180.0f));
    
    [UIView commitAnimations];
}

-(void)endAnimation
{

    angle += 10;
    
    if (angle <= angleTotal) {
        [self startAnimation];

    }
}
@end
