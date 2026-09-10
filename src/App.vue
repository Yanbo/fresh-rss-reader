<script setup>
import { useAppState } from './state/useAppState.js'
import FeedList from './components/FeedList.vue'
import ArticleList from './components/ArticleList.vue'
import ArticleView from './components/ArticleView.vue'
import { computed } from 'vue'

const { state, selectFeed, selectArticle, closeArticle, toggleFullscreen, openArticle } = useAppState()

const hasFeed = computed(() => state.currentFeedIndex >= 0)
</script>

<template>
  <div class="app" :class="{ fullscreen: state.articleViewMode === 'fullscreen' && hasFeed }">
    <FeedList :feeds="state.feedsList" :current-index="state.currentFeedIndex" @select="selectFeed" />
    <div class="main">
      <ArticleList
        v-if="hasFeed"
        :articles="state.feedsList[state.currentFeedIndex]?.articles || []"
        :current-index="state.currentArticleIndex"
        @select="selectArticle"
      />
      <ArticleView
        v-if="state.currentArticleIndex >= 0"
        :article="state.feedsList[state.currentFeedIndex]?.articles[state.currentArticleIndex]"
        :fullscreen="state.articleViewMode === 'fullscreen'"
        @close="closeArticle"
        @toggle-fullscreen="toggleFullscreen"
        @open="openArticle"
      />
    </div>
  </div>
</template>

<style scoped>
.app {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.app.fullscreen .main {
  flex: 1;
}

.main {
  flex: 1;
  display: flex;
  overflow: hidden;
}
</style>
