//
//  XTSettingsViewController.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTSettingsViewController.h"

@interface XTSettingsViewController ()

@end

@implementation XTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setContentInset:UIEdgeInsetsMake(70, 0, 50, 0)];
        self.tableView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        
        [self.view addSubview:_tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    NSArray *tableItems1 = [NSArray arrayWithObjects:@"Ski",@"Snowboard",@"Splitboard", nil];
    NSArray *tableItems2 = [NSArray arrayWithObjects:@"Originalbild speichern",@"Anonym aufzeichnen", nil];
    NSArray *tableItems3 = [NSArray arrayWithObjects:@"Safety Modus", nil];
    
    _tableArrays = [[NSDictionary alloc] initWithObjectsAndKeys:tableItems1, @"Mein Sportgerät", tableItems2, @"Diverses", tableItems3, @"Safety", nil];
    
    _sectionTitles = [[NSArray alloc] initWithObjects:@"Mein Sportgerät",@"Diverses", @"Safety", nil];
    
    _sectionFooter = [[NSArray alloc] initWithObjects:@"",@"",@"Bei Aktivierung stoppt die App automatisch das Aufzeichnen der GPS Daten wenn die Batterie unter 20% fällt.", nil];
    
    _selectedIndex = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [_sectionTitles objectAtIndex:section];
    NSArray *sectionItems = [_tableArrays objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"] autorelease];
    
    NSString *sectionTitle = [_sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [_tableArrays objectForKey:sectionTitle];
    
    cell.textLabel.text = [sectionItems objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == _selectedIndex) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
            
        case 1:
        {
            UISwitch *safetySwitch = [[[UISwitch alloc] init] autorelease];
            
            safetySwitch.frame = CGRectMake(cell.frame.size.width-safetySwitch.frame.size.width-10, (cell.frame.size.height - safetySwitch.frame.size.height)/2, 50, safetySwitch.frame.size.height);
            //[safetySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:safetySwitch];
            
            switch (indexPath.row) {
                case 0:
                    safetySwitch.on = true;
                    break;
                case 1:
                    safetySwitch.on = false;
                    break;
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.row == 0) {
                UISwitch *safetySwitch = [[[UISwitch alloc] init] autorelease];
                
                safetySwitch.frame = CGRectMake(cell.frame.size.width-safetySwitch.frame.size.width-10, (cell.frame.size.height - safetySwitch.frame.size.height)/2, 50, safetySwitch.frame.size.height);
                //[safetySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:safetySwitch];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            _selectedIndex = indexPath.row;
            break;
        case 1:
            break;
    }
    
    [tableView reloadData];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 200, 20)];
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTitle.textColor = [UIColor colorWithRed:150.0F/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [_sectionTitles objectAtIndex:section];
    
    [viewHeader addSubview:lblTitle];
    
    [lblTitle release];
    
    return viewHeader;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width-10, 70)];
    
    textView.font = [UIFont fontWithName:@"Helvetica" size:14];
    textView.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [_sectionFooter objectAtIndex:section];
    
    textView.scrollEnabled = false;
    
    [viewFooter addSubview:textView];
    
    [textView release];
    
    return viewFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {return 70.0;}
    else {return 0;}
}

- (IBAction)LoadLogin:(id)sender {
}

- (void)dealloc {
    [super dealloc];
}
@end
