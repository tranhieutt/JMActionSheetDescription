//
//  UICollectionView+AutoDelegation.m
//  Pods
//
//  Created by jerome morissard on 02/06/2015.
//
//

#import "UICollectionView+AutoDelegation.h"
#import "JMActionSheetCollectionItemCell.h"
#import "JMActionSheetItem.h"
#import <objc/runtime.h>

const char * const JMActionSheetCollectionDatasourceKey = "JMActionSheetCollectionDatasourceKey";
const char * const JMActionSheetCollectionViewBlockActionKey = "JMActionSheetCollectionViewBlockActionKey";
const char * const JMActionSheetCollectionDelegateKey = "JMActionSheetCollectionDelegateKey";
const char * const JMActionSheetActionDelegateKey = "JMActionSheetActionDelegateKey";

@implementation UICollectionView (AutoDelegation)

#pragma mark - Runtine Accessors

- (void)setJm_CollectionViewElements:(NSArray *)jm_elements
{
    objc_setAssociatedObject(self, JMActionSheetCollectionDatasourceKey, jm_elements, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)jm_CollectionViewElements
{
    NSArray *elements = (NSArray *) objc_getAssociatedObject(self, JMActionSheetCollectionDatasourceKey);
    return elements;
}

- (void)setJm_collectionActionBlock:(JMActionSheetSelectedItemBlock)jm_collectionActionBlock
{
    objc_setAssociatedObject(self, JMActionSheetCollectionViewBlockActionKey, jm_collectionActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (JMActionSheetSelectedItemBlock)jm_collectionActionBlock
{
    JMActionSheetSelectedItemBlock actionBlock = objc_getAssociatedObject(self, JMActionSheetCollectionViewBlockActionKey);
    return actionBlock;
}

- (void)setJm_actionSheetDelegate:(id<JMActionSheetViewControllerDelegate>)jm_actionSheetDelegate
{
    objc_setAssociatedObject(self, JMActionSheetActionDelegateKey, jm_actionSheetDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<JMActionSheetViewControllerDelegate>)jm_actionSheetDelegate
{
    id<JMActionSheetViewControllerDelegate>jm_actionSheetDelegate  = objc_getAssociatedObject(self, JMActionSheetActionDelegateKey);
    return jm_actionSheetDelegate;
}

#pragma mark - UICollectionViewDataSource

- (void)jm_registerCells
{
    [self registerClass:[JMActionSheetCollectionItemCell class] forCellWithReuseIdentifier:@"JMActionSheetCollectionItemCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self jm_CollectionViewElements].count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMActionSheetCollectionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JMActionSheetCollectionItemCell" forIndexPath:indexPath];
    id obj = [[self jm_CollectionViewElements] objectAtIndex:indexPath.row];
    [cell updateWithObject:obj forIndexPath:indexPath andDelegate:self.delegate];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [[self jm_CollectionViewElements] objectAtIndex:indexPath.row];
    [[self jm_actionSheetDelegate] actionSheetDidSelectCollectionView:collectionView element:obj block:[self jm_collectionActionBlock]];
}

@end