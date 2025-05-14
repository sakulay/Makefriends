import { HeaderContentType } from "../common/HeaderContentType"
import { Get, Post, Put, Delete } from "../utils/request"
import { Page } from "./friendsApi"

const CATEGORY_BASE_URL = "/api/v1/appPostCategorys"

/**
 * 分类查询参数
 */
export class CategoryQuery {
  pageNum: number;
  pageSize: number;
  isDeleted: number;

  constructor(pageNum: number, pageSize: number, isDeleted:number) {
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.isDeleted = isDeleted;
  }
}

/**
 * 分类表单对象
 */
export class CategoryForm {
  name: string;
  icon?: string;
  description?: string;
  sort?: number;

  constructor(name: string, icon?: string, description?: string, sort?: number) {
    this.name = name;
    this.icon = icon;
    this.description = description;
    this.sort = sort;
  }
}

/**
 * 分类模型
 */
export class CategoryModel {
  id: number
  name: string
  description: string
  sort: number
  createTime: string

  constructor(id: number, name: string, description: string, sort: number, createTime: string) {
    this.id = id
    this.name = name
    this.description = description
    this.sort = sort
    this.createTime = createTime
  }
}

/**
 * 获取帖子分类分页列表
 * @param queryParams 查询参数
 */
export function getCategoryPage(queryParams: CategoryQuery) {
  return Get<Page<CategoryModel>, CategoryQuery>(
    `${CATEGORY_BASE_URL}/page`,
    queryParams,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

/**
 * 新增帖子分类
 * @param formData 帖子分类表单数据
 */
export function saveCategory(formData: CategoryForm) {
  return Post<null, CategoryForm>(
    `${CATEGORY_BASE_URL}`,
    formData
  )
}

/**
 * 获取帖子分类表单数据
 * @param id 帖子分类ID
 */
export function getCategoryForm(id: string) {
  return Get<CategoryForm, null>(
    `${CATEGORY_BASE_URL}/${id}/form`,
    null,
    HeaderContentType.APPLICATION_JSON
  )
}

/**
 * 修改帖子分类
 * @param id 帖子分类ID
 * @param formData 帖子分类表单数据
 */
export function updateCategory(id: string, formData: CategoryForm) {
  return Put<null, CategoryForm>(
    `${CATEGORY_BASE_URL}/${id}`,
    formData
  )
}

/**
 * 删除帖子分类
 * @param ids 帖子分类ID，多个以英文逗号(,)分割
 */
export function deleteCategories(ids: string) {
  return Delete<null, null>(
    `${CATEGORY_BASE_URL}/${ids}`,
    null
  )
}

/**
 * 获取所有分类列表（简化版，无分页）
 */
export function getAllCategories() {
  return Get<CategoryModel[], null>(
    `${CATEGORY_BASE_URL}/list`,
    null,
    HeaderContentType.APPLICATION_JSON
  )
}

/**
 * 模拟分类数据（待后端接口实现后可移除）
 */
export const mockCategories: CategoryModel[] = [
  new CategoryModel(0, '全部', '所有分类', 0, ''),
  new CategoryModel(1, '学习', '学习交流', 1, ''),
  new CategoryModel(2, '生活', '日常生活', 2, ''),
  new CategoryModel(3, '情感', '情感分享', 3, ''),
  new CategoryModel(4, '求助', '问题求助', 4, ''),
  new CategoryModel(5, '活动', '校园活动', 5, ''),
  new CategoryModel(6, '运动', '运动健身', 6, '')
]