//
//  CommentViewController.m
//  InstagramReaderEx
//
//  Created by AlleyOops on 2015/6/19.
//  Copyright (c) 2015年 AlleyOops. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import <UIImageView+AFNetworking.h>

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    NSDictionary *comment = self.comments[[indexPath row]];
    NSDictionary *fromUser = comment[@"from"];
    [cell.profilePhotoView setImageWithURL:[NSURL URLWithString:fromUser[@"profile_picture"]]];
    cell.nameLabel.text = fromUser[@"username"];
    cell.commentLabel.text = comment[@"text"];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
