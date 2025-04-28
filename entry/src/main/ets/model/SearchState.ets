export class SearchState {
  private static instance: SearchState;
  private searchText: string = '';
  private listeners: ((text: string) => void)[] = [];

  private constructor() {}

  static getInstance(): SearchState {
    if (!SearchState.instance) {
      SearchState.instance = new SearchState();
    }
    return SearchState.instance;
  }

  setSearchText(text: string) {
    this.searchText = text;
    this.notifyListeners();
  }

  getSearchText(): string {
    return this.searchText;
  }

  addListener(listener: (text: string) => void) {
    this.listeners.push(listener);
  }

  removeListener(listener: (text: string) => void) {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  private notifyListeners() {
    this.listeners.forEach(listener => listener(this.searchText));
  }
} 