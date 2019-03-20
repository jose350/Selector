#import "SLCWindow.h"

UIWindow* SLCGetMainWindow() {
    return [[[UIApplication sharedApplication] windows] firstObject];
}

@implementation SLCWindow

@synthesize webViewConfig, webView, isOpen, gradientLayer, closeLabel, activityIndicatorView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.windowLevel = UIWindowLevelAlert + 1;

    [self setUserInteractionEnabled:YES];
    self.hidden = YES;

    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(0, 1.2);
    [self.layer insertSublayer:self.gradientLayer atIndex:0];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];

    self.webViewConfig = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height * 0.8) configuration:self.webViewConfig];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];

    self.closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height * 0.8,self.frame.size.width,self.frame.size.height * 0.2)];
    self.closeLabel.textAlignment = NSTextAlignmentCenter;
    self.closeLabel.textColor = [UIColor whiteColor];
    self.closeLabel.text = @"Tap here to close";
    [self.closeLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [self addSubview: self.closeLabel];

    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.frame = self.webView.frame;
    self.activityIndicatorView.hidesWhenStopped = true;
    [self.activityIndicatorView setUserInteractionEnabled:NO];
    [self.webView addSubview: self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];

    return self;
}

-(void)handleTap {
    [self setVisibility:false];
}

-(void)setVisibility:(bool)state {
    self.isOpen = state;
    if (state) {
        [self setHidden: NO];

        if (self.alpha != 1.0) self.alpha = 0.0;
        [UIView animateWithDuration:(0.3) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:NULL];

        [SLCGetMainWindow() endEditing:YES];
    } else {
        self.alpha = 1.0;

        [UIView animateWithDuration:(0.3) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0;
        } completion:NULL];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.3) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self setHidden: YES];
        });
    }
}

-(void)animateActivity {
    [self.activityIndicatorView startAnimating];
}

-(void)open:(NSString*)url {
    if (!self.isOpen) [self setVisibility:true];
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation {
    [self.activityIndicatorView stopAnimating];
}

@end