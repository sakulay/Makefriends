import { HeaderContentType } from "../common/HeaderContentType";
import { NewsCommentModel } from "../model/NewsCommentModel";
import { Get, Post } from "../utils/request";
import { UserSimpleInfo } from "../viewmodel/UserProfileModel";
import { Page } from "./friendsApi";

const COMMENT_BASE_URL = "/api/v1/appPostComments"

export class CommentForm {
  userId: string;
  parentId: string;
  postId: string;
  content: string;
  isReply: number;

  constructor (userId: string, parentId: string, postId: string, content: string, isReply: number) {
    this.userId = userId;
    this.parentId = parentId;
    this.postId = postId;
    this.content = content;
    this.isReply = isReply;
  }
}

export class AddComment{
  public id: string;
  public userInfo: UserSimpleInfo;

  constructor(id: string, userInfo: UserSimpleInfo) {
    this.id = id;
    this.userInfo = userInfo;
  }
}

/**
 * 评论查询参数
 */
export class CommentQuery {
  pageNum: number;
  pageSize: number;
  postId: number;

  constructor(pageNum: number, pageSize: number, postId: number) {
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.postId = postId;
  }
}

/**
 * 评论的数据结构
 */
export class CommentModel {
  // 评论id
  public id: string;
  // 评论头像
  public url: ResourceStr | string;
  // 评论昵称
  public user: string;
  // 用户id
  public userInfo?: UserSimpleInfo;
  // 回复id 通ParentId
  public replyId: string;
  // 回复用户昵称
  public replyUser: string;
  // 回复文本
  public text: string;
  // 回复时间
  public commentTime: Date;
  // 点赞数
  public likeCount: number;
  // 评论下的回复列表
  public replyList: CommentModel[];

  constructor(id: string, url: ResourceStr | string, user: string, replyId: string, replyUser: string, text: string, commentTime: Date, likeCount: number, replyList: CommentModel[], userInfo?: UserSimpleInfo) {
    this.id = id;
    this.url = url;
    this.user = user;
    this.userInfo = userInfo;
    this.replyId = replyId;
    this.replyUser = replyUser;
    this.text = text;
    this.commentTime = commentTime;
    this.likeCount = likeCount
    this.replyList = replyList;
  }
}

export function getCommentPageById(queryParams: CommentQuery) {
  return Get<Page<CommentModel>, CommentQuery>(
    `${COMMENT_BASE_URL}/pageById`,
    queryParams,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}
export function saveAppPostComment(commentForm: CommentForm) {
  return Post<AddComment, CommentForm>(
    `${COMMENT_BASE_URL}`,
    commentForm
  )
}