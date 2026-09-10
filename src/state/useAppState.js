import { reactive, readonly } from 'vue'

// Article data shape (minimum fields):
// {
//   title: string,       // article title
//   author: string,      // article author
//   pubDate: string,     // publication date
//   link: string,        // article URL
//   description: string, // article content/summary
//   read: boolean        // read status
// }

export const useAppState = () => {
  const state = reactive({
    feedsList: [],
    currentFeedIndex: -1,
    currentArticleIndex: -1,
    articleViewMode: 'inline', // 'inline' | 'fullscreen'
    feedsLinkList: []
  })

  function selectFeed(index) {
    if (index >= 0 && index < state.feedsList.length) {
      state.currentFeedIndex = index
      state.currentArticleIndex = -1  // 切换 feed 时重置文章选中
    }
  }

  function selectArticle(index) {
    if (state.currentFeedIndex >= 0 && state.currentFeedIndex < state.feedsList.length) {
      const articles = state.feedsList[state.currentFeedIndex].articles || []
      if (index >= 0 && index < articles.length) {
        state.currentArticleIndex = index
      }
    }
  }

  function closeArticle() { state.currentArticleIndex = -1 }

  function toggleFullscreen() {
    state.articleViewMode = state.articleViewMode === 'inline' ? 'fullscreen' : 'inline'
  }

  // 后续阶段实现的业务方法
  function openArticle() { /* TODO: 阶段 2 */ }
  function markArticleRead() { /* TODO: 阶段 2 */ }

  function addFeed(feed) {
    state.feedsList.push(feed)
  }

  function removeFeed(index) {
    if (index >= 0 && index < state.feedsList.length) {
      state.feedsList.splice(index, 1)
      // 修复索引：调整当前选中的 feed
      if (state.currentFeedIndex >= state.feedsList.length) {
        state.currentFeedIndex = state.feedsList.length - 1
      } else if (index < state.currentFeedIndex) {
        state.currentFeedIndex--
      } else if (index === state.currentFeedIndex) {
        state.currentArticleIndex = -1  // 删除当前 feed 时重置文章选中
      }
    }
  }

  return {
    state: readonly(state),
    selectFeed,
    selectArticle,
    closeArticle,
    toggleFullscreen,
    openArticle,
    markArticleRead,
    addFeed,
    removeFeed
  }
}
