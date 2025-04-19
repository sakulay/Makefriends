import { HeaderContentType } from "../common/HeaderContentType";
import { Delete, Get, Post } from "../utils/request";
import { AuthModel, LoginForm } from "../viewmodel/AuthModel";

const AUTH_BASE_URL = "/api/v1/auth/app"

export function login<T>(auth: LoginForm) {
  return Post<T, LoginForm>(
    `${AUTH_BASE_URL}/login`,
    auth,
    HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED
  )
}

export function logout() {
  return Delete<null, null>(
    `${AUTH_BASE_URL}/logout`
  )
}

export function register(authmodel: AuthModel) {
  return Post<string, AuthModel>(
    `${AUTH_BASE_URL}/register`,
    authmodel
  )
}