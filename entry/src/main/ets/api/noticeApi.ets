import { HeaderContentType } from '../common/HeaderContentType';
import { Get } from '../utils/request';
import { Page } from './friendsApi';


const NOTICE_BASE_URL = '/api/v1/notices';

export class NoticePageQuery {
  pageNum: number;
  pageSize: number;
  title?: string;
  type?: number;
  publishStatus?: number;
  level?: string;
  targetType?: number;

  constructor(pageNum: number, pageSize: number, title?: string, type?: number, publishStatus?: number, level?: string, targetType?: number) {
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.title = title;
    this.type = type;
    this.publishStatus = publishStatus;
    this.level = level;
    this.targetType = targetType;
  }
}

export class NoticeModel {
  id: string;
  title: string;
  publishStatus: number;
  type: number;
  publisherName: string;
  level: string;
  publishTime: string;
  isRead: boolean | null;
  targetType: number;
  createTime: string;
  revokeTime: string | null;

  constructor(id: string, title: string, publishStatus: number, type: number, publisherName: string, level: string, publishTime: string, isRead: boolean | null, targetType: number, createTime: string, revokeTime: string | null) {
    this.id = id;
    this.title = title;
    this.publishStatus = publishStatus;
    this.type = type;
    this.publisherName = publisherName;
    this.level = level;
    this.publishTime = publishTime;
    this.isRead = isRead;
    this.targetType = targetType;
    this.createTime = createTime;
    this.revokeTime = revokeTime;
  }
}

export function getNoticePage(query: NoticePageQuery) {
  return Get<Page<NoticeModel>, NoticePageQuery>(
    `${NOTICE_BASE_URL}/page`,
    query,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

export class NoticeDetailVO {
  id: string;
  title: string;
  content: string;
  publishStatus: number;
  type: number;
  publisherName: string;
  level: string;
  publishTime: string;
  isRead: boolean;
  targetType: number;
  createTime: string;
  revokeTime: string | null;

  constructor(id: string, title: string, content: string, publishStatus: number, type: number, publisherName: string, level: string, publishTime: string, isRead: boolean, targetType: number, createTime: string, revokeTime: string | null) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.publishStatus = publishStatus;
    this.type = type;
    this.publisherName = publisherName;
    this.level = level;
    this.publishTime = publishTime;
    this.isRead = isRead;
    this.targetType = targetType;
    this.createTime = createTime;
    this.revokeTime = revokeTime;
  }
}

export function getNoticeDetail(id: string) {
  return Get<NoticeDetailVO, null>(
    `${NOTICE_BASE_URL}/${id}/detail`,
    null,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
} 