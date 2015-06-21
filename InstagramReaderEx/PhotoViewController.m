//
//  PhotoViewController.m
//  InstagramReaderEx
//
//  Created by AlleyOops on 2015/6/19.
//  Copyright (c) 2015年 AlleyOops. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCell.h"
#import <UIImageView+AFNetworking.h>
#import "CommentViewController.h"


@interface PhotoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"-> viewDidLoad");
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // infinite load
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen  mainScreen].bounds.size.width,50)];
    UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadView startAnimating];
    loadView.center = tableFooterView.center;
    [tableFooterView addSubview:loadView];
    self.tableView.tableFooterView = tableFooterView;

    
    
    self.photos = [[NSArray alloc] init];
    [self queryInstagramAPI];
}

- (void)onRefresh {
    [self queryInstagramAPI];
}

- (void)queryInstagramAPI{
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=1fd852f936f0478087f061ec225e5060"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *newPhotos = dict[@"data"];
        self.photos = [self.photos arrayByAddingObjectsFromArray:[newPhotos subarrayWithRange:NSMakeRange(0, 2)]];
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.photos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //return [self.photos count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *photo = self.photos[section];
    NSString *urlString = [photo valueForKeyPath:@"user.profile_picture"];
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    UIImageView *profilePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [profilePhotoView setImageWithURL:[NSURL URLWithString:urlString]];
    [sectionHeaderView addSubview:profilePhotoView];
    profilePhotoView.center = sectionHeaderView.center;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    NSDictionary *photo = self.photos[[indexPath section]];
    NSString *urlString = [photo valueForKeyPath:@"images.standard_resolution.url"];
    [cell.mainPhotoView setImageWithURL:[NSURL URLWithString:urlString]];
    
    if ([self.photos count] == [indexPath section] + 1) {
        // last cell so load new photos
        [self queryInstagramAPI];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PhotoCell *cell = (PhotoCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *photo = self.photos[[indexPath row]];
    NSArray *comments = [photo valueForKeyPath:@"comments.data"];
    comments = [comments subarrayWithRange:NSMakeRange(0, 5)];
    CommentViewController *destinationVC = [segue destinationViewController];
    [destinationVC setValue:comments forKey:@"comments"];
}


@end
