//
//  MyXIBViewController.m
//  OCTableSectionExpand
//
//  Created by Don Mag on 6/28/17.
//  Copyright © 2017 DonMag. All rights reserved.
//

#import "MyXIBViewController.h"

#import "MyXIBTableViewCell.h"

@interface MyXIBViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak,nonatomic) IBOutlet UITableView * tableView;

@end

#define numSections 28
NSInteger rowsInEachSection[numSections];
NSInteger sectionIsExpanded[numSections];

@implementation MyXIBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	for (int i = 0; i < numSections; i++) {
		// put 2 to 5 rows in each section (we always display the first row)
		rowsInEachSection[i] = (i % 5) + 2;
		
		// set all sections to currently Expanded
		sectionIsExpanded[i] = YES;
	}
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	// auto-sizing cells
	self.tableView.estimatedRowHeight = 40.0;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	// register a "default" cell for reuse
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FirstRowCell"];
	
	// register our custom cell in a xib for reuse
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyXIBTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyXIBTableViewCell class])];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return numSections;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// if the section is currently Expanded, return the number of rows... else, return 1 (always show the first row)
	return sectionIsExpanded[section] ? rowsInEachSection[section] : 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// if its the first row in a section, use a "default" cell
	if (indexPath.row == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstRowCell" forIndexPath:indexPath];
		cell.textLabel.text = [NSString stringWithFormat:@"Section %ld - tap to show/hide", (long)indexPath.section];
		cell.backgroundColor = [UIColor cyanColor];
		return cell;
	}
	
	// not the first row, so use our custom cell from a xib file
	MyXIBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyXIBTableViewCell class]) forIndexPath:indexPath];
	
	// just give it some text - make it two lines, so we see it auto-size the height
	cell.theLabel.text = [NSString stringWithFormat:@"Row %ld \n in Section %ld", (long)indexPath.row, (long)indexPath.section];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	// if it's the First row in a section
	if (indexPath.row == 0) {
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		NSMutableArray *a = [NSMutableArray array];
		
		// build an array of IndexPaths for this section
		for (int row = 1; row < rowsInEachSection[indexPath.section]; row++) {
			[a addObject:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
		}

		[tableView beginUpdates];

		if (sectionIsExpanded[indexPath.section]) {
			// we're removing cells
			
			[tableView deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationNone];
			
		} else {
			// we're adding cells

			[tableView insertRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationNone];

		}
		
		// flip this section's Expanded flag
		sectionIsExpanded[indexPath.section] = !sectionIsExpanded[indexPath.section];
		
		[tableView endUpdates];
		
	}
	
}


@end
