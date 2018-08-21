//
//  MovieDetails.m
//  sampleProject
//
//  Created by Abhishek on 21/08/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import "MovieDetails.h"

@interface MovieDetails ()

@end

@implementation MovieDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView = [self.imgCache objectForKey:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/images?api_key=c29cd39013365864984d43aef4b1f833&language=en-US",[self.dict objectForKey:@"id"]]];
    self.lblOrginalTitle.text = [NSString stringWithFormat:@"Original Title:\n%@",[self.dict objectForKey:@"original_title"]];
    self.lblSynopsis.text = [NSString stringWithFormat:@"Synopsis:\n%@",[self.dict objectForKey:@"overview"]];
    self.lblRating.text = [NSString stringWithFormat:@"Voter Average: %@",[self.dict objectForKey:@"vote_average"]];
    self.lblReleaseDate.text = [NSString stringWithFormat:@"Release Date: %@",[self.dict objectForKey:@"release_date"]];
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
