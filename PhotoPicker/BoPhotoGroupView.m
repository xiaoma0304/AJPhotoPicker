//
//  BoPhotoGroupView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoPhotoGroupView.h"
#import "BoPhotoGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MacroDefine.h"

@interface BoPhotoGroupView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation BoPhotoGroupView

#pragma mark - lifecycle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(void)initCommon{
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[BoPhotoGroupCell class] forCellReuseIdentifier:@"cell"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = mRGBToColor(0xebebeb);
    self.showEmptyGroups = YES;
}

-(void)setupGroup{
    //读取分组
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group){
            [group setAssetsFilter:self.assetsFilter];
            if (group.numberOfAssets > 0 || self.showEmptyGroups){
                [self.groups addObject:group];
                
                if (self.groups.count == 1) {
                    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
                        [_my_delegate didSelectGroup:group];
                    }
                }
                
            }
        }else{
            [self dataReload];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //没权限
        [self showNotAllowed];
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    
}

#pragma mark - ALAssetsLibrary
+ (ALAssetsLibrary *)defaultAssetsLibrary{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Reload Data
- (void)dataReload{
    if (self.groups.count == 0)
        //没有图片
        [self showNoAssets];
    
    [self reloadData];
}

#pragma mark - Not allowed / No assets
- (void)showNotAllowed{}
- (void)showNoAssets{}


#pragma mark - uitableviewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"cell";
    BoPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    if(cell == nil){
        cell = [[BoPhotoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    if (indexPath.row == self.selectIndex) {
        cell.backgroundColor = mRGBToColor(0xd9d9d9);
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self reloadData];
    ALAssetsGroup *group = [self.groups objectAtIndex:indexPath.row];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:group];
    }
}


@end