//
//  MovieDetails.h
//  sampleProject
//
//  Created by Abhishek on 21/08/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetails : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblOrginalTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblReleaseDate;
@property (weak, nonatomic) NSDictionary *dict;
@property (weak, nonatomic) NSCache *imgCache;

@end
