// 引入包名
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { HttpConstant } from '../common/HttpConstant';
import { ErrorContants } from '../common/ErrorContants';
import { Result } from './Result'
import { HeaderContentType } from '../common/HeaderContentType';
import { AuthenticationToken } from '../viewmodel/AuthModel';
const LOG = "request"
export function request<T,K>(url: string, method: http.RequestMethod, data?: K, contentType?: string) {
  // 每一个httpRequest对应一个HTTP请求任务，不可复用
  let httpRequest = http.createHttp();
  // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
  console.log(`[request] ${method} request: ` + HttpConstant.URL + url);
  console.log("[request] data: ", JSON.stringify(data))
  console.log("[request] contentType: ", contentType)
  /**
   * 获取并构造token
   */
  const auth: AuthenticationToken = AppStorage.get('auth') as AuthenticationToken
  let token: string = ''
  if(auth) {
    token = `${auth.tokenType} ${auth.accessToken}`
    console.log("[request] token: ", token)
  }
  // token = HttpConstant.AUTH_TOKEN
  // ✅ 构造 headers（防止空 Authorization）
  const headers: Record<string, string> = {
    'Content-Type': contentType ? contentType : 'application/json'
  };
  if (token) {
    headers['Authorization'] = token;
  }
  const requestOptions: http.HttpRequestOptions =
    {
      method: method, // 可选，默认为http.RequestMethod.GET
      // 开发者根据自身业务需要添加header字段
      header: headers,
    }
  // 非 DELETE 请求、非表单数据才传 extraData
  if (method !== http.RequestMethod.DELETE && contentType != HeaderContentType.MULTIPART_FORM_DATA && data) {
    requestOptions.extraData = dataHandle(data, contentType)
  }
  if (contentType == HeaderContentType.MULTIPART_FORM_DATA) {
    requestOptions.multiFormDataList = data as Array<http.MultiFormData>
  }
  /**
   * 发起请求
   */
  return new Promise((resolve: (value: T)=>void, reject: (value: string)=>void)=>{
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      HttpConstant.URL + url,
      requestOptions,
      (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        /**
         * data.result后端数据
         * @code @msg @data
         */
        console.log("[request] data.result: "+ data.result)
        let res: Result<T> = JSON.parse(`${data.result}`)
        if(res.code == '00000') {
          resolve(res.data)
        } else {
          reject(res.msg ?? ErrorContants.UNKNOWN_ERR)
        }

        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      } else {
        console.error('error:' + JSON.stringify(err));
        // 当该请求使用完毕时，调用destroy方法主动销毁
        httpRequest.destroy();
      }
    }
    );
  })
}

export function Get<T,K>(url: string, data?: K, contentType?: string): Promise<T> {
  return request<T,K>(url, http.RequestMethod.GET, data, contentType)
}

export function Post<T,K>(url: string, data: K, contentType?: string): Promise<T> {
  return request<T,K>(url, http.RequestMethod.POST, data, contentType)
}

export function Delete<T,K>(url: string, data?: K, contentType?: string): Promise<T> {
  return request<T,K>(url, http.RequestMethod.DELETE, data)
}

export function Put<T,K>(url: string, data?: K, contentType?: string): Promise<T> {
  return request<T,K>(url, http.RequestMethod.PUT, data, contentType)
}

function encodeFormData(data: object) {
  const params: string = Object.keys(data).filter(key => data[key] !== null && data[key] !== undefined)
    .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(data[key]))
    .join('&');
  console.log("[request] params: ", params)
  return params
}

function dataHandle<K>(data: K, contenType?: string): string{
  if(data) {
    if( contenType && contenType == HeaderContentType.APPLICATION_X_WWW_FORM_URLENCODED) {
      return encodeFormData(data as object)
    } else {
      return JSON.stringify(data)
    }
  } else {
    return ""
  }
}