import { router } from '@kit.ArkUI';
import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct SearchPage {
  @State searchText: string = ''
  @State searchHistory: string[] = []
  private static readonly STORAGE_NAME = 'search_history'
  private static readonly HISTORY_KEY = 'history_list'
  private static readonly MAX_HISTORY = 10
  private preferences: dataPreferences.Preferences | null = null
  
  async aboutToAppear() {
    try {
      const context = getContext(this) as common.UIAbilityContext;
      this.preferences = await dataPreferences.getPreferences(context, SearchPage.STORAGE_NAME);
      const history = await this.preferences.get(SearchPage.HISTORY_KEY, '[]');
      this.searchHistory = JSON.parse(history as string);
    } catch (e) {
      console.error('Failed to load search history:', e);
    }
  }

  async saveSearchHistory(keyword: string) {
    if (!keyword.trim() || !this.preferences) return;
    
    let history = [...this.searchHistory];
    // 移除重复项
    history = history.filter(item => item !== keyword);
    // 添加到开头
    history.unshift(keyword);
    // 限制数量
    if (history.length > SearchPage.MAX_HISTORY) {
      history = history.slice(0, SearchPage.MAX_HISTORY);
    }
    
    this.searchHistory = history;
    try {
      await this.preferences.put(SearchPage.HISTORY_KEY, JSON.stringify(history));
      await this.preferences.flush();
    } catch (e) {
      console.error('Failed to save search history:', e);
    }
  }

  async clearHistory() {
    if (!this.preferences) return;
    
    try {
      const result = await promptAction.showDialog({
        title: '确认清除',
        message: '确定要清除所有搜索历史吗？',
        buttons: [
          {
            text: '取消',
            color: '#666666'
          },
          {
            text: '确定',
            color: '#007DFF'
          }
        ]
      });
      
      if (result.index === 1) { // 用户点击了确定
        this.searchHistory = [];
        await this.preferences.delete(SearchPage.HISTORY_KEY);
        await this.preferences.flush();
        promptAction.showToast({ message: '历史记录已清除' });
      }
    } catch (e) {
      console.error('Failed to clear search history:', e);
      promptAction.showToast({ message: '清除失败，请重试' });
    }
  }
  
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(22)
          .height(22)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })

        // 搜索输入框
        Row() {
          TextInput({ placeholder: '搜索帖子...', text: this.searchText })
            .width('75%')
            .height(40)
            .backgroundColor('#F5F5F5')
            .borderRadius(20)
            .padding({ left: 15, right: 15 })
            .fontSize(16)
            .onChange((value: string) => {
              this.searchText = value
            })
          Image($r('app.media.ic_search'))
            .width(24)
            .height(24)
            .margin({ left: 10 })
            .onClick(async () => {
              if (this.searchText.trim()) {
                await this.saveSearchHistory(this.searchText)
                router.pushUrl({
                  url: 'pages/search/SearchResult',
                  params: {
                    keyword: this.searchText
                  }
                })
              }
            })
        }
        .width('100%')
        .padding({
          left: 16,
          right: 16,
          top: 16,
          bottom: 16
        })
        .backgroundColor(Color.White)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 搜索区域
      Column() {
        if (this.searchHistory.length > 0) {
          // 搜索历史
          Column() {
            Row() {
              Text('搜索历史')
                .fontSize(16)
                .fontWeight(500)
                .fontColor('#333333')
              Blank()
              Image($r('app.media.ic_delete_rubish'))
                .width(20)
                .height(20)
                .onClick(async () => {
                  await this.clearHistory()
                })
            }
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 16,
              bottom: 8
            })

            // 历史记录标签
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.searchHistory, (item: string) => {
                Text(item)
                  .fontSize(14)
                  .fontColor('#666666')
                  .backgroundColor('#F5F5F5')
                  .borderRadius(16)
                  .padding({
                    left: 12,
                    right: 12,
                    top: 6,
                    bottom: 6
                  })
                  .margin({ right: 8, bottom: 8 })
                  .onClick(() => {
                    this.searchText = item
                    router.pushUrl({
                      url: 'pages/search/SearchResult',
                      params: {
                        keyword: item
                      }
                    })
                  })
              })
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 16 })
          }
          .backgroundColor(Color.White)
          .margin({ top: 8 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
  }
}