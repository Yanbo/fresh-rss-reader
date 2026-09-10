<script setup>
defineProps({
  feeds: { type: Array, default: () => [] },
  currentIndex: { type: Number, default: -1 }
})
defineEmits(['select'])
</script>

<template>
  <aside class="feed-list">
    <h2>Feeds</h2>
    <ul>
      <li v-for="(feed, i) in feeds" :key="feed.url || i" :class="{ active: i === currentIndex }">
        {{ feed.title || feed.url }}
      </li>
    </ul>
    <p v-if="feeds.length === 0" class="empty">暂无 feed，请添加订阅</p>
  </aside>
</template>

<style scoped>
.feed-list {
  width: 200px;
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
  padding: 8px;
  cursor: pointer;
  border-radius: 4px;
}

li:hover,
li.active {
  background-color: var(--select-color);
}

.empty {
  color: var(--read-color);
  font-size: 14px;
}
</style>
