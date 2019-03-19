#import <WebKit/WebKit.h>

@interface SLCWindow : UIWindow <WKNavigationDelegate>

@property (nonatomic, retain) WKWebViewConfiguration* webViewConfig;
@property (nonatomic, retain) WKWebView* webView;
@property (nonatomic, retain) UILabel* closeLabel;
@property (nonatomic, assign) bool isOpen;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) CAGradientLayer* gradientLayer;

-(void)setVisibility:(bool)state;
-(void)handleTap;
-(void)open:(NSString*)url;
-(void)animateActivity;

@end