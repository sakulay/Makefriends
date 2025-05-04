export class AppPostBrowseRecord {
  id: string = '';
  postId: string = '';
  userId: string = '';
  createTime: string = '';
  postTitle: string = '';
  postContent: string = '';
  postImage: string = '';
}

export class AppPostBrowseRecordQuery {
  pageNum: number = 1;
  pageSize: number = 10;
  viewerId: string = '';
}

export class AppPostBrowseRecordForm {
  postId: string = '';
  viewerId: string = '';
} 