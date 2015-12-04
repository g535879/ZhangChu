//
//  DBManager.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/12/1.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"


@interface DBManager () {
    //数据库对象
    FMDatabase * _database;
}

@end
static DBManager * _singleten = nil;

@implementation DBManager

+ (DBManager *)shareManager {
    
    
    if (!_singleten) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            _singleten = [[super alloc] init];
        });
    }
    return _singleten;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _singleten = [super allocWithZone:zone];
        
    });
                      
  return _singleten;
}


- (instancetype) init {
    
    self = [super init];
    
    if (self) {

        
        NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Documents/appabc.db"];
        
        _database = [[FMDatabase alloc] initWithPath:path];
        
        if (_database.open) {
    
            //数据库创建表格
            NSString * sql = @"create table if not exists zhangchu("
            "vegetable_id varchar(132),"
            "name varchar(128),"
            "imagePathThumbnails varchar(1024)"
            ")";
            
            if ([_database executeUpdate:sql]) {
                NSLog(@"表创建成功");
            }
            else{
                NSLog(@"%@",_database.lastError);
            }
        }
        else{
            NSLog(@"sqlite open error");
        }
    }
    return self;
}

- (void)insertDataWithModel:(CookBookDetailModel *)model {
    
    @synchronized(self) {
        
        NSString * sql = @"insert into zhangchu(vegetable_id,name,imagePathThumbnails) values(?,?,?)";
        if (![_database executeUpdate:sql,model.vegetable_id,model.name,model.imagePathThumbnails]) {
            NSLog(@"插入失败%@",_database.lastErrorMessage);
        }
    }
}

- (void)deleteDataWithModel:(CookBookDetailModel *)model {
    
    @synchronized(self) {
        NSString * sql = @"delete from zhangchu where vegetable_id=?";
        if (![_database executeUpdate:sql,model.vegetable_id]) {
            NSLog(@"删除失败%@",_database.lastErrorMessage);
        }
    }
}

- (void)updateDataWithModel:(CookBookDetailModel *)model {
    
    @synchronized(self) {
        NSString * sql = @"update zhangchu set imagePathThumbnails=? name=? where vegetable_id=?";
        if (![_database executeUpdate:sql,model.imagePathThumbnails,model.name,model.vegetable_id]) {
            NSLog(@"更新失败%@",_database.lastErrorMessage);
        }
    }
}

- (NSArray *)selectDataByModel:(CookBookDetailModel *)model {
    @synchronized(self) {
        NSString * sql = @"select * from zhangchu where vegetable_id=?";
        NSMutableArray * resultArray = [@[] mutableCopy];
        
        FMResultSet * set = [_database executeQuery:sql,model.vegetable_id];
        while (set.next) {
            
            CookBookDetailModel * model = [[CookBookDetailModel alloc] init];
            model.vegetable_id = [set stringForColumn:@"vegetable_id"];
            model.name = [set stringForColumn:@"name"];
            model.imagePathThumbnails = [set stringForColumn:@"imagePathThumbnails"];
            
            [resultArray addObject:model];
        }
        return resultArray;
    }
}


- (NSArray *)selectAll {
    
    
    @synchronized(self) {
        NSString * sql = @"select * from zhangchu";
        NSMutableArray * resultArray = [@[] mutableCopy];
        
        FMResultSet * set = [_database executeQuery:sql];
        while (set.next) {
            
            CookBookDetailModel * model = [[CookBookDetailModel alloc] init];
            
            model.vegetable_id = [set stringForColumn:@"vegetable_id"];
            model.name = [set stringForColumn:@"name"];
            model.imagePathThumbnails = [set stringForColumn:@"imagePathThumbnails"];
            
            [resultArray addObject:model];
        }
        return resultArray;
    }
    
    
}


//+ (DBManager *)shareManager {
//    
//    @synchronized(self) {
//        if (!_singleten) {
//            
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                _singleten = [[DBManager alloc] init];
//            });
//        }
//    }
//    return _singleten;
//}
@end
