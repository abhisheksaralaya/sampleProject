//
//  ViewController.h
//  sampleProject
//
//  Created by Abhishek on 08/08/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connect.h"
#import "MovieDetails.h"
@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>{
    __weak IBOutlet UICollectionView *tblView;
    __weak IBOutlet UISearchBar *searchBar;
}

- (IBAction)btnSort:(id)sender;


@end

@interface CollectionCell : UICollectionViewCell


@end
