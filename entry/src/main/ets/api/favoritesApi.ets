import { HeaderContentType } from "../common/HeaderContentType";
import { Delete, Get, Post } from "../utils/request";
import { Page } from "./friendsApi";
import { PostModel } from "./postApi";

const FAVORITES_BASE_URL = "/api/v1/appPostFavoritess"

export class  FavoritesQuery {
  pageNum: number = 1;
  pageSize: number = 10;
  viewerId: string = '';
}

export interface FavoritesForm {
  postId: string;
  userId: string;
}

export interface FavoritesCheckQuery {
  postId: string;
  studentId: string;
}

export interface FavoritesCheckResult {
  id: string;
  isFavorited: boolean;
}
export class FavoritesVO {
  id: string = '';
  postId: string = '';
}

export function getFavoritesPage(query: FavoritesQuery) {
  return Get<Page<PostModel>, FavoritesQuery>(
    `${FAVORITES_BASE_URL}/page`,
    query,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

export function getFavoriteRecord(userId: string, postId: string) {
  return Get<FavoritesVO, null>(
    `${FAVORITES_BASE_URL}/record/${userId}/${postId}`
  )
}

export function saveFavorites(form: FavoritesForm) {
  return Post<null, FavoritesForm>(
    `${FAVORITES_BASE_URL}`,
    form
  )
}

export function deleteFavorites(userId: string, postId: string) {
  return Delete<null, null>(
    `${FAVORITES_BASE_URL}?userId=${userId}&postId=${postId}`
  );
}
export function checkFavoritesStatus(query: FavoritesCheckQuery) {
  return Get<FavoritesCheckResult, FavoritesCheckQuery>(
    `${FAVORITES_BASE_URL}/check`,
    query,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
} 