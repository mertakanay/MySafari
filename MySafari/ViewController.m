//
//  ViewController.m
//  MySafari
//
//  Created by tim on 3/11/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (nonatomic) CGFloat contentY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    self.urlTextField.delegate = self;
    self.webView.scrollView.delegate = self;
    self.activityIndicator.hidesWhenStopped = YES;


    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;


    //allow user to clear textfield
    self.urlTextField.clearButtonMode = YES;

}

//load URL service method
- (void) performLoadURLRequest:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)onBackButtonPressed:(id)sender {

    [self.webView goBack];
}

- (IBAction)onPreviousButtonPressed:(id)sender {
    [self.webView goForward];
    }

- (IBAction)onStopButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}


- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:nil delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];

    [alertview show];
}


#pragma mark UIScrollViewDelegate protocols
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.contentY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //make textfield apprear or disappear: if webview drag up: textfield disappear
    if(self.contentY >= scrollView.contentOffset.y)
    {
        self.urlTextField.alpha = 0.0;
    }
    else{
        self.urlTextField.alpha = 1.0;
    }
}

#pragma mark UITextFieldDelegate Protocols

//add http:// string if user does not provide
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    NSString *urlString;
    NSLog(@"text URL is %@", textField.text);

    NSString *head = [textField.text substringToIndex:6];

    if(![head isEqualToString:@"http://"]){

        urlString = [NSString stringWithFormat:@"http://%@",textField.text];
    }

    [self performLoadURLRequest:urlString];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UIWebViewDelegate Protocols



-(void)webViewDidStartLoad:(UIWebView *)webView
{
     [self.activityIndicator startAnimating];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];

    self.activityIndicator.hidesWhenStopped=YES;

    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;

    //display current URL in textfield
    self.urlTextField.text = webView.request.URL.absoluteString;

    //display webpage title in navigation bar's title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
