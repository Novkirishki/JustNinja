//
//  HighscoreTableViewCell.h
//  Just Ninja
//
//  Created by Nikolai Novkirishki on 2/3/16.
//  Copyright © 2016 Nikolai Novkirishki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
