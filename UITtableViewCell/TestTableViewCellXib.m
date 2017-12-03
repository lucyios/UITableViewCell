//
//  TestTableViewCellXib.m
//  UITtableViewCell
//
//  Created by lilx on 2017/11/30.
//  Copyright © 2017年 liluxin. All rights reserved.
//

#import "TestTableViewCellXib.h"


@interface TestTableViewCellXib()


@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end


@implementation TestTableViewCellXib


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.text = title;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
