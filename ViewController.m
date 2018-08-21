//
//  ViewController.m
//  sampleProject
//
//  Created by Abhishek on 08/08/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    Connect *connect;
    NSMutableArray *arrMovies;
    NSCache *imgCache;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    connect = [[Connect alloc] init];
    arrMovies = [[NSMutableArray alloc] init];
    searchBar.delegate = self;
    [tblView setDataSource:self];
    [tblView setDelegate:self];
    
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    if (searchText.length > 0) {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [connect requestNewWithURL:[NSString stringWithFormat:@"https://api.themoviedb.org/3/search/movie?api_key=c29cd39013365864984d43aef4b1f833&language=en-US&query=%@",searchText] postString:@"" completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error && (resp.statusCode == 201 || resp.statusCode == 200)) {
                    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    [self->arrMovies removeAllObjects];
                    [self->arrMovies addObjectsFromArray:[dataDict objectForKey:@"results"]];
                    [self->tblView reloadData];
                } else {
                    NSLog(@"asssss");
                }
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrMovies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *dict = [arrMovies objectAtIndex:indexPath.row];
    
    NSLog(@"qwertyui====%@\nasxdfvgbhnjk%@",dict,arrMovies);
    NSString *imgUrlStr = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/images?api_key=c29cd39013365864984d43aef4b1f833&language=en-US",[dict objectForKey:@"id"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 142, 140, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [label setText:[dict objectForKey:@"original_title"]];
    
    [cell.contentView addSubview:label];
    
    UIImage *image = [imgCache objectForKey:imgUrlStr];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    if (image) {
        imgView.image=image;
        [cell.contentView addSubview:imgView];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:[imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *imgData = [NSData dataWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc] initWithData:imgData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    imgView.image=image;
                    [self->imgCache setObject:image forKey:imgUrlStr];
                    NSLog(@"qwertyuqqww");
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else {
                    UIImage *image = [UIImage imageNamed:@"placeholder.png"];
                    imgView.image = image;
                    [self->imgCache setObject:image forKey:imgUrlStr];
                }
                
                [cell.contentView addSubview:imgView];
            });
        });
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"trdcyfggy");
    MovieDetails *details = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovieDetails"];
    NSDictionary *dict = [arrMovies objectAtIndex:indexPath.row];
    details.imgCache = imgCache;
    details.dict = dict;
    [self.navigationController pushViewController:details animated:YES];
}
- (IBAction)btnSort:(id)sender {
}
@end
