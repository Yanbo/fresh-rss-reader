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

  return {
    state: readonly(state),
    selectFeed,
    selectArticle,
    closeArticle,
    toggleFullscreen
  }
}
