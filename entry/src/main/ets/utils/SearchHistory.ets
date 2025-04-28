 import { Storage } from '@kit.ArkUI';

export class SearchHistory {
  private static readonly HISTORY_KEY = 'search_history';
  private static readonly MAX_HISTORY_COUNT = 10;

  /**
   * 保存搜索历史
   * @param keyword 搜索关键词
   */
  static saveHistory(keyword: string): void {
    if (!keyword.trim()) return;
    
    let history = this.getHistory();
    // 移除重复项
    history = history.filter(item => item !== keyword);
    // 添加到开头
    history.unshift(keyword);
    // 限制数量
    if (history.length > this.MAX_HISTORY_COUNT) {
      history = history.slice(0, this.MAX_HISTORY_COUNT);
    }
    
    Storage.set(this.HISTORY_KEY, JSON.stringify(history));
  }

  /**
   * 获取搜索历史
   * @returns 搜索历史数组
   */
  static getHistory(): string[] {
    const historyStr = Storage.get(this.HISTORY_KEY) as string;
    if (!historyStr) return [];
    try {
      return JSON.parse(historyStr);
    } catch (e) {
      return [];
    }
  }

  /**
   * 清除搜索历史
   */
  static clearHistory(): void {
    Storage.delete(this.HISTORY_KEY);
  }
}