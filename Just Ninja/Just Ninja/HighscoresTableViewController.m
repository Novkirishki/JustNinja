//
//  HighscoresTableViewController.m
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/3/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

#import "HighscoresTableViewController.h"
#import "HighscoreTableViewCell.h"
#import <Parse/Parse.h>
#import "Just_Ninja-Swift.h"

@interface HighscoresTableViewController ()

@end

@implementation HighscoresTableViewController


@synthesize highscores = _highscores;

- (NSMutableArray *)highscores {
    if (!_highscores) {
        _highscores = [[NSMutableArray alloc] init];
    }
    
    return _highscores;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(play:)];
    self.navigationItem.leftBarButtonItem = playButton;
    
    self.tableView.rowHeight = 88;
}

- (void) play:(UIBarButtonItem *)sender {
    GameViewController *controller = [[GameViewController alloc] init];
    [self.navigationController presentViewController:controller animated:TRUE completion:nil];
}

-(void) loadData {
    [self.highscores removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Highscore"];
    [query orderByDescending:@"Score"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [self.highscores addObject:object];
            }
            
            [self.tableView reloadData];
        }
    }];
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
    
    PFObject *highscore = [self.highscores objectAtIndex:indexPath.row];
    
    NSNumber *scoreAsNumber = [highscore objectForKey:@"Score"];
    NSString *highscoreAsString = [scoreAsNumber stringValue];
    cell.scoreLabel.text = highscoreAsString;
    cell.usernameLabel.text = [highscore objectForKey:@"Username"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.dateLabel.text = [dateFormatter stringFromDate:highscore.createdAt];
    
    PFFile *userImage = highscore[@"Image"];
    NSData *imageData = [userImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    [cell.imageView setClipsToBounds:TRUE];
    cell.imageView.image = image;
    
    return cell;
}

@end
