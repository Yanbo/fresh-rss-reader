import { reactive, readonly } from 'vue'

export const useAppState = () => {
  const state = reactive({
    feedsList: [],
    currentFeedIndex: -1,
    currentArticleIndex: -1,
    articleViewMode: 'inline', // 'inline' | 'fullscreen'
    feedsLinkList: []
  })

  function selectFeed(index) { state.currentFeedIndex = index }
  function selectArticle(index) { state.currentArticleIndex = index }
  function closeArticle() { state.currentArticleIndex = -1 }
  function toggleFullscreen() {
    state.articleViewMode = state.articleViewMode === 'inline' ? 'fullscreen' : 'inline'
  }

  // 后续阶段实现的业务方法
  function openArticle() { /* TODO: 阶段 2 */ }
  function markArticleRead() { /* TODO: 阶段 2 */ }
  function addFeed(feed) { state.feedsList.push(feed) }
  function removeFeed(index) { state.feedsList.splice(index, 1) }

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
