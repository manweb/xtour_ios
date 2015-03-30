//
//  XTWarnigsViewController.m
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTWarnigsViewController.h"

@interface XTWarnigsViewController ()

@end

@implementation XTWarnigsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    data = [XTDataSingleton singleObj];
    
    _listOfFiles = [data GetAllImages];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }

    [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [_listOfFiles count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listOfFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    // Get filename
    NSString *currentFile = [_listOfFiles objectAtIndex:indexPath.row];
    NSArray *parts = [currentFile componentsSeparatedByString:@"/"];
    NSString *fname = [parts lastObject];
    
    cell.textLabel.text = fname;
    if ([[fname pathExtension] isEqualToString:@"jpg"]) {
        cell.imageView.image = [UIImage imageNamed:currentFile];
    }
    
    return cell;
}

- (void)dealloc {
    [_loginButton release];
    [super dealloc];
}
- (IBAction)loadLogin:(id)sender {
    if (!login) {login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];}
    [self presentViewController:login animated:YES completion:nil];
    
    [login release];
    login = nil;
}

@end
