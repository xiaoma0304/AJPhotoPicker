//
//  BoPhotoPickerViewController.h
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class BoPhotoPickerViewController;
@protocol BoPhotoPickerProtocol <NSObject>

//选择完成
-(void)photoPicker:(BoPhotoPickerViewController *)picker didSelectAssets:(NSArray *)asset;

//取消
-(void)photoPickerDidCancel:(BoPhotoPickerViewController *)picker;

//超过最大选择项时
-(void)photoPickerDidMaximum:(BoPhotoPickerViewController *)picker;

//低于最低选择项时
-(void)photoPickerDidMinimum:(BoPhotoPickerViewController *)picker;

@end





@interface BoPhotoPickerViewController : UIViewController

@property (weak, nonatomic) id<BoPhotoPickerProtocol> delegate;

//组过滤
@property (nonatomic, strong) NSPredicate *selectionFilter;
//资源过滤
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

//选中的项
@property (nonatomic, copy, readonly) NSArray *indexPathsForSelectedItems;

//最多选择项
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
//最少选择项
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

//显示取消按钮
@property (nonatomic, assign) BOOL showCancelButton;
//显示空相册
@property (nonatomic, assign) BOOL showEmptyGroups;

//多选
@property (nonatomic) BOOL multipleSelection;
@end