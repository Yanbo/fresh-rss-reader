<script setup>
  import { onMounted, onUnmounted } from 'vue'

  defineProps({
    article: { type: Object, default: () => ({}) },
    fullscreen: { type: Boolean, default: false }
  })
  defineEmits(['close', 'toggle-fullscreen', 'open'])

  // Keyboard shortcuts:
  //   'q' : close current article
  //   'f' : open current article (if not already open)
  function handleKeydown(e) {
    if (e.key === 'q') {
      $emit('close')
    }
    if (e.key === 'f') {
      $emit('open')
    }
  }

  onMounted(() => {
    document.addEventListener('keydown', handleKeydown)
  })

  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
</script>

<template>
  <div class="article-view" :class="{ fullscreen }">
    <div class="article-header">
      <h1>{{ article.title || '无标题' }}</h1>
      <div class="article-meta">
        <span v-if="article.author">{{ article.author }}</span>
        <span v-if="article.pubDate"> · {{ article.pubDate }}</span>
      </div>
      <div class="article-actions">
        <button @click="$emit('toggle-fullscreen')">
          {{ fullscreen ? '退出全屏' : '全屏' }}
        </button>
        <button @click="$emit('close')">关闭</button>
      </div>
    </div>
    <div class="article-content">
      <p v-if="article.description">{{ article.description }}</p>
      <p v-else class="empty">暂无内容</p>
    </div>
  </div>
</template>

<style scoped>
.article-view {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}

.article-view.fullscreen {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--bg-color);
  z-index: 100;
}

.article-header {
  margin-bottom: 20px;
}

h1 {
  margin: 0 0 10px;
  font-size: 24px;
}

.article-meta {
  color: var(--read-color);
  font-size: 14px;
}

.article-actions {
  margin-top: 10px;
}

.article-actions button {
  margin-right: 10px;
  padding: 6px 12px;
  cursor: pointer;
}

.article-content {
  line-height: 1.6;
}

.empty {
  color: var(--read-color);
}
</style>
