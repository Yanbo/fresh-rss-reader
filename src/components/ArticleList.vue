<script setup>
defineProps({
  articles: { type: Array, default: () => [] },
  currentIndex: { type: Number, default: -1 }
})
defineEmits(['select'])
</script>

<template>
  <aside class="article-list">
    <h2>Articles</h2>
    <ul>
      <li v-for="(article, i) in articles" :key="article.link || i" :class="{ active: i === currentIndex, read: article.read }">
        <div class="article-title">{{ article.title || '无标题' }}</div>
        <div class="article-meta">{{ article.author }} · {{ article.pubDate }}</div>
      </li>
    </ul>
    <p v-if="articles.length === 0" class="empty">暂无文章</p>
  </aside>
</template>

<style scoped>
.article-list {
  width: 300px;
  border-right: 1px solid var(--line-color);
  padding: 10px;
  overflow-y: auto;
}

h2 {
  margin: 0 0 10px;
  font-size: 16px;
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

li {
  padding: 10px;
  cursor: pointer;
  border-radius: 4px;
}

li:hover,
li.active {
  background-color: var(--select-color);
}

li.read {
  color: var(--read-color);
}

.article-title {
  font-weight: 500;
}

.article-meta {
  font-size: 12px;
  color: var(--read-color);
  margin-top: 4px;
}

.empty {
  color: var(--read-color);
  font-size: 14px;
}
</style>
