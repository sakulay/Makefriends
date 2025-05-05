import { HeaderContentType } from "../common/HeaderContentType";
import { Get, Post, Put, Delete } from "../utils/request";
import { Page } from "./friendsApi";

const COMPLAINT_BASE_URL = "/api/v1/appComplaints"

export interface ComplaintItem {
  id: number
  userId: string
  complaintType: string | null
  complaintDescription: string
  complaintTargetType: number // 1: 帖子, 2: 评论
  complaintTargetId: string
  status: number // 0: 待处理, 1: 已处理, 2: 已拒绝, 3: 已关闭
  createTime: string
  updateTime: string
  isDeleted: number
}

export interface ComplaintForm {
  complaintType: string
  complaintDescription: string
  complaintTargetType: number
  complaintTargetId: string
}

// 获取举报列表
export function getComplaintList() {
  return Get<Page<ComplaintItem>, null>(
    `${COMPLAINT_BASE_URL}/page`
  )
}

// 新增举报
export function addComplaint(data: ComplaintForm) {
  return Post<null, ComplaintForm>(
    COMPLAINT_BASE_URL,
    data
  )
}

// 获取举报详情
export function getComplaintDetail(id: number) {
  return Get<ComplaintForm, null>(
    `${COMPLAINT_BASE_URL}/${id}/form`
  )
}

// 更新举报
export function updateComplaint(id: number, data: ComplaintForm) {
  return Put<null, ComplaintForm>(
    `${COMPLAINT_BASE_URL}/${id}`,
    data
  )
}

// 删除举报
export function deleteComplaint(ids: string) {
  return Delete<null, null>(
    `${COMPLAINT_BASE_URL}/${ids}`
  )
} 