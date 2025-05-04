export class PostState {
  private static instance: PostState;
  private listeners: ((postId: number, likeCount: number) => void)[] = [];
  private LOG = "[PostState]"

  private constructor() {}

  static getInstance(): PostState {
    if (!PostState.instance) {
      PostState.instance = new PostState();
    }
    return PostState.instance;
  }

  updatePostLike(postId: number, likeCount: number) {
    console.log(this.LOG, `更新点赞状态: postId=${postId}, likeCount=${likeCount}, 监听器数量=${this.listeners.length}`)
    this.notifyListeners(postId, likeCount);
  }

  addListener(listener: (postId: number, likeCount: number) => void) {
    console.log(this.LOG, `添加监听器, 当前监听器数量=${this.listeners.length}`)
    this.listeners.push(listener);
  }

  removeListener(listener: (postId: number, likeCount: number) => void) {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      console.log(this.LOG, `移除监听器, 当前监听器数量=${this.listeners.length}`)
      this.listeners.splice(index, 1);
    }
  }

  private notifyListeners(postId: number, likeCount: number) {
    console.log(this.LOG, `通知所有监听器: postId=${postId}, likeCount=${likeCount}`)
    this.listeners.forEach(listener => listener(postId, likeCount));
  }
} 