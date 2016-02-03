//
//  HighscoresTableViewController.m
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/3/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

#import "HighscoresTableViewController.h"

#import "HighscoreTableViewCell.h"

@interface HighscoresTableViewController ()

@end

@implementation HighscoresTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    self.tableView.rowHeight = 88;
}

-(void) loadData {
    self.highscores = [NSArray arrayWithObjects:@"345", @"21", @"32",nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.highscores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"highscoreCell";
    
    HighscoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HighscoreTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.scoreLabel.text = [self.highscores objectAtIndex:indexPath.row];
    
    return cell;
}

@end
