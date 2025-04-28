import { HeaderContentType } from "../common/HeaderContentType"
import { Get } from "../utils/request"
import { Page } from "./friendsApi"

const NEWS_BASE_URL = '/api/v1/appNewss'
export class NewsQuery{
  public pageNum: number
  public pageSize: number

  constructor(page: number, pageSize: number) {
    this.pageNum = page
    this.pageSize = pageSize
  }
}
export class NewsModel{
  date: string;
  title: string;
  content: string;

  constructor(date: string, title: string, content: string) {
    this.date = date;
    this.title = title;
    this.content = content;
  }
}

export function getAppNewsPage(params: NewsQuery) {
  return Get<Page<NewsModel>,NewsQuery>(
    `${NEWS_BASE_URL}/page`,
    params,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}