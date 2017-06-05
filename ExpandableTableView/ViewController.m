//
//  ViewController.m
//  ExpandableTableView
//
//  Created by milan on 05/05/16.
//  Copyright © 2016 apps. All rights reserved.
//

#import "ViewController.h"

#import "ViewControllerCell.h"

#import "ViewControllerCellHeader.h"

#include <stdlib.h>

#define count 20

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tblView;
    NSMutableArray *arrSelectedSectionIndex;
    BOOL isMultipleExpansionAllowed;
}
@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set isMultipleExpansionAllowed = true is multiple expanded sections to be allowed at a time. Default is NO.
    isMultipleExpansionAllowed = YES;
    
    arrSelectedSectionIndex = [[NSMutableArray alloc] init];

    if (!isMultipleExpansionAllowed) {
        [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:count+2]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - TableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
    {
        return 4;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
    
    if (cell ==nil)
    {
        [tblView registerClass:[ViewControllerCell class] forCellReuseIdentifier:@"ViewControllerCell"];
        
        cell = [tblView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
    }
    
    cell.lblName.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];

    cell.backgroundColor = indexPath.row%2==0?[UIColor lightTextColor]:[[UIColor lightTextColor] colorWithAlphaComponent:0.5f];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ViewControllerCellHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    
    if (headerView ==nil)
    {
        [tblView registerClass:[ViewControllerCellHeader class] forCellReuseIdentifier:@"ViewControllerCellHeader"];

        headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
    }

    headerView.lbTitle.text = [NSString stringWithFormat:@"Section %ld", (long)section];
    
    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
    {
        headerView.btnShowHide.selected = YES;
    }
    
    [[headerView btnShowHide] setTag:section];
    
    [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];

    return headerView.contentView;
}

-(IBAction)btnTapShowHideSection:(UIButton*)sender
{
    if (!sender.selected)
    {
        if (!isMultipleExpansionAllowed) {
            [arrSelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:sender.tag]];
        }else {
            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }

        sender.selected = YES;
    }else{
        sender.selected = NO;
        
        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
    }

    if (!isMultipleExpansionAllowed) {
        [tblView reloadData];
    }else {
        [tblView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
