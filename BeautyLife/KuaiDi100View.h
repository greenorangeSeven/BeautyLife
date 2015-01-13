//
//  KuaiDi100View.h
//  BeautyLife
//
//  Created by Seven on 14-8-26.
//  Copyright (c) 2014年 Seven. All rights reserved.
// 快递100嵌入界面
//

#import <UIKit/UIKit.h>

@interface KuaiDi100View : UIViewController<UIWebViewDelegate>

//快递名称
@property (weak, nonatomic) NSString *expcom;
//快递单号
@property (weak, nonatomic) NSString *expnum;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
