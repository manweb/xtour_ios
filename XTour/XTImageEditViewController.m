//
//  XTImageEditViewController.m
//  XTour
//
//  Created by Manuel Weber on 25/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTImageEditViewController.h"

@interface XTImageEditViewController ()

@end

@implementation XTImageEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImageInfo:(XTImageInfo *)image andID:(NSUInteger)ID
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        imageInfo = image;
        _imageID = ID;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [XTDataSingleton singleObj];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    self.view.frame = CGRectMake(0, 0, width, height+tabBarHeight);
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    
    _imageEditView = [[UIView alloc] initWithFrame:CGRectMake(280, 30, 0, 0)];
    _imageEditView.layer.cornerRadius = 10.0f;
    _imageEditView.layer.borderWidth = 5.0f;
    _imageEditView.layer.borderColor = [UIColor grayColor].CGColor;
    _imageEditView.backgroundColor = [UIColor whiteColor];
    
    _imageInfoComment = [[UITextView alloc] initWithFrame:CGRectMake(20, 35, 260, 120)];
    [_imageInfoComment setAlpha:0.0f];
    
    _imageInfoComment.layer.borderWidth = 1.0f;
    _imageInfoComment.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _imageInfoComment.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    _imageInfoComment.text = imageInfo.Comment;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake(100, 170, 100, 20);
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(220, 10, 80, 20);
    
    [_loginButton setTitle:@"Eintragen" forState:UIControlStateNormal];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [_loginButton addTarget:self action:@selector(Enter) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageEditView addSubview:_loginButton];
    [_imageEditView addSubview:_cancelButton];
    [_imageEditView addSubview:_imageInfoComment];
    
    [self.view addSubview:_imageEditView];
    
    [_loginButton release];
    [_cancelButton release];
}

- (void)Enter {
    if ([imageInfo.Filename containsString:@"http://www.xtour.ch"]) {
        XTServerRequestHandler *request = [[XTServerRequestHandler alloc] init];
        
        NSArray *filename = [imageInfo.Filename componentsSeparatedByString:@"/"];
        NSString *fname = [filename lastObject];
        
        [request SubmitImageComment:_imageInfoComment.text forImage:fname];
        
        [request release];
    }
    else {
        [data GetImageInfoAt:_imageID].Comment = _imageInfoComment.text;
    }
    
    [self HideView];
}

- (void)Cancel {
    [self HideView];
}

- (void) animate
{
    [self ShowView];
}

- (void) ShowView
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    double yOffset;
    
    if (height == 480) {yOffset = 40;}
    if (height == 568) {yOffset = 80;}
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        _imageEditView.frame = CGRectMake(0, yOffset-10, width, 220);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_imageEditView.frame = CGRectMake(15, yOffset+5, width-30, 190);} completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                _imageEditView.frame = CGRectMake(10, yOffset, width-20, 200);
                
                [_imageInfoComment setAlpha:1.0f];
                [_loginButton setAlpha:1.0f];
                [_cancelButton setAlpha:1.0f];
            } completion:NULL
             ];
        }];
    }];
}

- (void) HideView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        _imageEditView.frame = CGRectMake(280, 30, 0, 0);
        
        [_imageInfoComment setAlpha:0.0f];
        [_loginButton setAlpha:0.0f];
        [_cancelButton setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageEditView release];
    [_imageInfoComment release];
    [_loginButton release];
    [_cancelButton release];
    [super dealloc];
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
