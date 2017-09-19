//
//  JYJAdDetailViewController.m
//  shanqi
//
//  Created by JYJ on 2017/9/14.
//  Copyright © 2017年 FlashBike. All rights reserved.
//

#import "JYJAdDetailViewController.h"
#import <WebKit/WebKit.h>

@interface JYJAdDetailViewController () <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation JYJAdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
    
    self.title = @"广告详细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.urlString.length) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LazyLoad
- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        webView.navigationDelegate = self;
        self.webView = webView;
    }
    return _webView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
