import { HeaderContentType } from "../common/HeaderContentType"
import { Get, Post, Delete } from "../utils/request"
import { Page } from "./friendsApi"

const POST_LIKE_BASE_URL = "/api/v1/appPostLikes"

/**
 * 点赞记录查询参数
 */
export class PostLikeQuery {
  pageNum: number;
  pageSize: number;
  userId?: number;
  postId?: number;

  constructor(pageNum: number, pageSize: number, userId?: number, postId?: number) {
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.userId = userId;
    this.postId = postId;
  }
}

/**
 * 点赞记录表单
 */
export class PostLikeForm {
  userId: number;
  postId: number;

  constructor(userId: number, postId: number) {
    this.userId = userId;
    this.postId = postId;
  }
}

/**
 * 获取点赞记录分页列表
 */
export function getPostLikePage(queryParams: PostLikeQuery) {
  return Get<Page<PostLikeForm>, PostLikeQuery>(
    `${POST_LIKE_BASE_URL}/page`,
    queryParams,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

/**
 * 新增点赞记录
 */
export function savePostLike(form: PostLikeForm) {
  return Post<null, PostLikeForm>(
    `${POST_LIKE_BASE_URL}`,
    form
  )
}

/**
 * 删除点赞记录
 */
export function deletePostLike(ids: string) {
  return Delete<null, null>(
    `${POST_LIKE_BASE_URL}/${ids}`
  )
} 