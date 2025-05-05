import { HeaderContentType } from "../common/HeaderContentType";
import { Delete, Get, Post } from "../utils/request";
import { AppPostBrowseRecordQuery, AppPostBrowseRecordForm } from "../model/AppPostBrowseRecord";
import { Page } from "./friendsApi";
import { PostModel } from "./postApi";


const BROWSE_RECORD_BASE_URL = "/api/v1/appPostBrowseRecords"

export function getBrowseRecordPage(query: AppPostBrowseRecordQuery) {
  return Get<Page<PostModel>, AppPostBrowseRecordQuery>(
    `${BROWSE_RECORD_BASE_URL}/page`,
    query,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

export function saveBrowseRecord(form: AppPostBrowseRecordForm) {
  return Post<null, AppPostBrowseRecordForm>(
    BROWSE_RECORD_BASE_URL,
    form
  )
}

export function deleteBrowseRecordsById(ids: string) {
  return Delete<null, null>(
    `${BROWSE_RECORD_BASE_URL}/${ids}`
  )
}

export function deleteBrowseRecords(viewerId: string, postId: string) {
  return Delete<null, null>(
    `${BROWSE_RECORD_BASE_URL}/viewer/${viewerId}/post/${postId}}`
  )
}
