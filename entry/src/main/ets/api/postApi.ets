import { HeaderContentType } from "../common/HeaderContentType"
import { Get, Post } from "../utils/request"
import { UserSimpleInfo } from "../viewmodel/UserProfileModel"
import { Page } from "./friendsApi"

const POST_BASE_URL = "/api/v1/appPosts"
/**
 * 帖子模型
 */
export class PostModel{
  id: number
  userId: number
  title: string
  content: string
  imageList: PostImage[]
  likeCount: number
  commentCount: number
  createTime: string
  userInfo: UserSimpleInfo

  constructor(id: number, userId: number, title: string, content: string, imgList: PostImage[], likeCount: number, commentCount: number, createTime: string, userInfo: UserSimpleInfo) {
    this.id = id;
    this.userId = userId;
    this.title = title;
    this.content = content;
    this.imageList = imgList;
    this.likeCount = likeCount;
    this.commentCount = commentCount;
    this.createTime = createTime;
    this.userInfo = userInfo;
  }
}
/**
 * 帖子查询参数
 */
export class PostQuery {
  pageNum: number;
  pageSize: number;
  status?: number;
  userId?: number;
  title?: string;

  constructor(pageNum: number, pageSize: number, status?: number, userId?: number, title?: string) {
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.status = status;
    this.userId = userId;
    this.title = title;
  }
}
/**
 * 帖子图片
 */
export class PostImage{
  id: string;
  postId: string;
  imageUrl: string;
  deleteUrl: string;
  imageOrder?: number;
  createTime?: string;
  isDeleted?: number;
  constructor(id: string, postId: string, imageUrl: string, deleteUrl: string, imageOrder?: number, createTime?: string, isDeleted?: number) {
    this.id = id;
    this.postId = postId;
    this.imageUrl = imageUrl;
    this.deleteUrl = deleteUrl;
    this.imageOrder = imageOrder;
    this.createTime = createTime;
    this.isDeleted = isDeleted;
  }
}
/**
 * 获取推荐帖子列表
 * @param queryParams
 * @returns
 */
export function getRecPostList(queryParams: PostQuery) {
  return Get<Page<PostModel>, PostQuery>(
    `${POST_BASE_URL}/page`,
    queryParams,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

export function saveAppPost(post: PostModel) {
  return Post<null, PostModel>(
    `${POST_BASE_URL}`,
    post
  )
}

