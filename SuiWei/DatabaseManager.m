//
//  DataBaseManager.m
//  WeiboTest
//
//  Created by lucas on 5/9/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

@synthesize database = _database;

- (void)dealloc
{
    self.database = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        NSString *path = NSHomeDirectory();
        path = [[path stringByAppendingPathComponent:@"/documents/data.db"] retain];
        self.database = [FMDatabase databaseWithPath:path];
        [path release];
        BOOL res = [_database open];
        if (!res) {
            NSLog(@"打开数据库失败");
            return self;
        }
        res = [_database executeUpdate:@"create table if not exists weibo(id, authorImageURL, author, postTime, comments, reports, content, imageURL, postSource, reAuthor, reContent, reImageURL)"];
        if (!res) {
            NSLog(@"创建表格失败");
            return self;
        }
    }
    return self;
}

- (BOOL)databaseInsert:(WeiboStatus *)status
{
    BOOL res = [_database executeUpdate:@"insert into weibo values(?,?,?,?,?,?,?,?,?,?,?,?)",status.idStr, status.authorImageStr, status.authorStr, status.timeStr, status.commentsStr, status.repostsStr, status.contentStr, status.imgStr, status.sourceStr, status.reAuthorStr, status.reContentStr, status.reImageStr];
    if (!res) {
        NSLog(@"插入数据失败");
        return NO;
    }
    return YES;
}

- (NSMutableArray *)databaseAllStatuses
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *set = [_database executeQuery:@"select * from weibo order by id desc"];
    while ([set next]) {
        WeiboStatus *status = [[WeiboStatus alloc] init];
        status.authorImageStr = [set stringForColumn:@"authorImageURL"];
        status.commentsStr = [set stringForColumn:@"comments"];
        status.repostsStr = [set stringForColumn:@"reports"];
        status.authorStr = [set stringForColumn:@"author"];
        status.timeStr = [set stringForColumn:@"postTime"];
        status.contentStr = [set stringForColumn:@"content"];
        status.imgStr = [set stringForColumn:@"imageURL"];
        status.sourceStr = [set stringForColumn:@"postSource"];
        status.idStr = [set stringForColumn:@"id"];
        status.reAuthorStr = [set stringForColumn:@"reAuthor"];
        status.reContentStr = [set stringForColumn:@"reContent"];
        status.reImageStr = [set stringForColumn:@"reImageURL"];
        [array addObject:status];
        [status release];
    }
    return array;
}

- (NSString *)databaseGetId:(BOOL)max
{
    FMResultSet *set;
    if (max) {
        set = [_database executeQuery:@"select id from weibo order by id desc"];
    }else{
        set = [_database executeQuery:@"select id from weibo order by id"];
    }
    [set next];
    return [set stringForColumnIndex:0];
}

- (BOOL)databaseDropTable
{
    BOOL res = [_database executeUpdate:@"drop table weibo"];
    if (!res) {
        NSLog(@"删除表格失败");
        return NO;
    }
    return YES;
}

- (void)databaseClose
{
    [_database close];
    return;
}


@end
