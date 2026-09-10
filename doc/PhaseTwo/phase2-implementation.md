# Fresh RSS Reader 阶段2实现文档

创建日期：2026-09-10
项目：fresh-rss-reader
文档类型：实现文档
状态：进行中
作者：opencode
审查者：待定
相关文件：doc/architecture.md, doc/implementation-phases.md, doc/phaseone/phase1-implementation.md

---

## 1. 阶段目标

实现 feed 列表、文章列表、文章详情三个主要视图，并能在前端展示和切换。

### 1.1 核心要求

- **FeedList.vue**：渲染 feed 列表，选择当前 feed，已读/未读的视觉反馈
- **ArticleList.vue**：渲染当前 feed 的文章，选择文章，已读高亮，当前选中保持可见
- **ArticleView.vue**：展示文章信息，支持 inline 和全屏两种显示方式，全屏切换由状态驱动
- **useAppState.js**：定义状态和切换函数
- **App.vue**：根据状态控制区域显隐

---

## 2. 实现步骤

### 2.1 状态模块扩充

**目标**：在 `useAppState.js` 中添加 mock 数据和完整的状态管理

**主要任务**：
- 添加 mock feeds 数据
- 实现 `openArticle()` 方法（打开文章链接）
- 实现 `markArticleRead()` 方法（标记已读）
- 完善状态切换逻辑

**Mock 数据结构**：
```javascript
const mockFeeds = [
  {
    title: '示例 Feed 1',
    url: 'https://example.com/feed1',
    articles: [
      {
        title: '文章标题 1',
        author: '作者 A',
        pubDate: '2026-09-10',
        link: 'https://example.com/article1',
        description: '文章描述内容...',
        read: false
      },
      // 更多文章...
    ]
  },
  // 更多 feeds...
]
```

### 2.2 FeedList.vue 增强

**目标**：增强 feed 列表的交互和视觉反馈

**主要任务**：
- 添加 feed 未读数量显示
- 添加 feed 选中态的视觉反馈（背景色、边框）
- 添加 feed 点击事件处理
- 优化空状态提示

**接口约定**：
```vue
<FeedList
  :feeds="state.feedsList"
  :current-index="state.currentFeedIndex"
  @select="selectFeed"
/>
```

### 2.3 ArticleList.vue 增强

**目标**：增强文章列表的交互和视觉反馈

**主要任务**：
- 添加文章已读/未读的视觉区分
- 添加文章选中态的视觉反馈
- 添加文章点击事件处理
- 优化空状态提示
- 当前选中文章保持可见（滚动到可见区域）

**接口约定**：
```vue
<ArticleList
  :articles="currentFeedArticles"
  :current-index="state.currentArticleIndex"
  @select="selectArticle"
/>
```

### 2.4 ArticleView.vue 增强

**目标**：增强文章详情的展示和交互

**主要任务**：
- 完善文章内容展示（标题、作者、时间、描述）
- 完善全屏切换逻辑
- 完善关闭按钮逻辑
- 优化键盘快捷键处理（q 关闭，f 打开）
- 添加文章链接跳转

**接口约定**：
```vue
<ArticleView
  :article="currentArticle"
  :fullscreen="state.articleViewMode === 'fullscreen'"
  @close="closeArticle"
  @toggle-fullscreen="toggleFullscreen"
  @open="openArticle"
/>
```

### 2.5 App.vue 布局优化

**目标**：优化根组件的布局和状态管理

**主要任务**：
- 优化左右布局比例
- 优化全屏模式下的布局
- 添加状态计算属性
- 完善组件间通信

---

## 3. 文件清单

| 文件路径 | 说明 | 状态 | 备注 |
|----------|------|------|------|
| src/state/useAppState.js | 状态模块 | 已存在 | 需要扩充 mock 数据和业务方法 |
| src/components/FeedList.vue | Feed 列表组件 | 已存在 | 需要增强交互和视觉反馈 |
| src/components/ArticleList.vue | 文章列表组件 | 已存在 | 需要增强交互和视觉反馈 |
| src/components/ArticleView.vue | 文章详情组件 | 已存在 | 需要增强展示和交互 |
| src/App.vue | 根组件 | 已存在 | 需要优化布局和状态管理 |

---

## 4. 实现细节

### 4.1 状态模块扩充

**useAppState.js 更新**：
```javascript
import { reactive, readonly } from 'vue'

// Mock 数据
const mockFeeds = [
  {
    title: '示例 Feed 1',
    url: 'https://example.com/feed1',
    articles: [
      {
        title: '文章标题 1',
        author: '作者 A',
        pubDate: '2026-09-10',
        link: 'https://example.com/article1',
        description: '这是文章描述内容...',
        read: false
      },
      {
        title: '文章标题 2',
        author: '作者 B',
        pubDate: '2026-09-09',
        link: 'https://example.com/article2',
        description: '另一篇文章描述...',
        read: true
      }
    ]
  },
  {
    title: '示例 Feed 2',
    url: 'https://example.com/feed2',
    articles: []
  }
]

export const useAppState = () => {
  const state = reactive({
    feedsList: mockFeeds,  // 使用 mock 数据
    currentFeedIndex: -1,
    currentArticleIndex: -1,
    articleViewMode: 'inline',
    feedsLinkList: []
  })

  // ... 其他方法保持不变 ...

  function openArticle() {
    // 打开文章链接
    if (state.currentFeedIndex >= 0 && state.currentArticleIndex >= 0) {
      const article = state.feedsList[state.currentFeedIndex].articles[state.currentArticleIndex]
      if (article && article.link) {
        window.open(article.link, '_blank')
      }
    }
  }

  function markArticleRead() {
    // 标记当前文章为已读
    if (state.currentFeedIndex >= 0 && state.currentArticleIndex >= 0) {
      const article = state.feedsList[state.currentFeedIndex].articles[state.currentArticleIndex]
      if (article) {
        article.read = true
      }
    }
  }

  // ... 其他方法保持不变 ...
}
```

### 4.2 FeedList.vue 增强

**主要改进**：
- 添加 feed 未读数量显示
- 优化选中态视觉反馈
- 添加 feed 点击事件处理

**关键代码**：
```vue
<script setup>
defineProps({
  feeds: { type: Array, default: () => [] },
  currentIndex: { type: Number, default: -1 }
})
defineEmits(['select'])

function getUnreadCount(feed) {
  return (feed.articles || []).filter(a => !a.read).length
}
</script>

<template>
  <aside class="feed-list">
    <h2>Feeds</h2>
    <ul>
      <li
        v-for="(feed, i) in feeds"
        :key="feed.url || i"
        :class="{ active: i === currentIndex }"
        @click="$emit('select', i)"
      >
        <span class="feed-title">{{ feed.title || feed.url }}</span>
        <span v-if="getUnreadCount(feed) > 0" class="unread-badge">
          {{ getUnreadCount(feed) }}
        </span>
      </li>
    </ul>
    <p v-if="feeds.length === 0" class="empty">暂无 feed，请添加订阅</p>
  </aside>
</template>
```

### 4.3 ArticleList.vue 增强

**主要改进**：
- 添加文章已读/未读的视觉区分
- 优化选中态视觉反馈
- 添加文章点击事件处理
- 当前选中文章保持可见

**关键代码**：
```vue
<script setup>
import { ref, watch, nextTick } from 'vue'

const props = defineProps({
  articles: { type: Array, default: () => [] },
  currentIndex: { type: Number, default: -1 }
})
defineEmits(['select'])

const listRef = ref(null)

// 当选中文章变化时，滚动到可见区域
watch(() => props.currentIndex, async (newIndex) => {
  if (newIndex >= 0 && listRef.value) {
    await nextTick()
    const items = listRef.value.querySelectorAll('li')
    if (items[newIndex]) {
      items[newIndex].scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    }
  }
})
</script>

<template>
  <aside class="article-list">
    <h2>Articles</h2>
    <ul ref="listRef">
      <li
        v-for="(article, i) in articles"
        :key="article.link || i"
        :class="{ active: i === currentIndex, read: article.read }"
        @click="$emit('select', i)"
      >
        <div class="article-title">{{ article.title || '无标题' }}</div>
        <div class="article-meta">{{ article.author }} · {{ article.pubDate }}</div>
      </li>
    </ul>
    <p v-if="articles.length === 0" class="empty">暂无文章</p>
  </aside>
</template>
```

### 4.4 ArticleView.vue 增强

**主要改进**：
- 完善文章内容展示
- 完善全屏切换逻辑
- 优化键盘快捷键处理
- 添加文章链接跳转

**关键代码**：
```vue
<script setup>
import { onMounted, onUnmounted } from 'vue'

defineProps({
  article: { type: Object, default: () => ({}) },
  fullscreen: { type: Boolean, default: false }
})
defineEmits(['close', 'toggle-fullscreen', 'open'])

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
        <button @click="$emit('open')">打开链接</button>
        <button @click="$emit('close')">关闭</button>
      </div>
    </div>
    <div class="article-content">
      <p v-if="article.description">{{ article.description }}</p>
      <p v-else class="empty">暂无内容</p>
    </div>
  </div>
</template>
```

### 4.5 App.vue 布局优化

**主要改进**：
- 优化左右布局比例
- 优化全屏模式下的布局
- 添加状态计算属性

**关键代码**：
```vue
<script setup>
import { useAppState } from './state/useAppState.js'
import FeedList from './components/FeedList.vue'
import ArticleList from './components/ArticleList.vue'
import ArticleView from './components/ArticleView.vue'
import { computed } from 'vue'

const { state, selectFeed, selectArticle, closeArticle, toggleFullscreen, openArticle, markArticleRead } = useAppState()

const hasFeed = computed(() => state.currentFeedIndex >= 0)
const hasArticle = computed(() => state.currentArticleIndex >= 0)
const currentFeedArticles = computed(() => {
  if (state.currentFeedIndex >= 0 && state.feedsList[state.currentFeedIndex]) {
    return state.feedsList[state.currentFeedIndex].articles || []
  }
  return []
})
</script>

<template>
  <div class="app" :class="{ fullscreen: state.articleViewMode === 'fullscreen' && hasFeed }">
    <FeedList :feeds="state.feedsList" :current-index="state.currentFeedIndex" @select="selectFeed" />
    <div class="main">
      <ArticleList
        v-if="hasFeed"
        :articles="currentFeedArticles"
        :current-index="state.currentArticleIndex"
        @select="selectArticle"
      />
      <ArticleView
        v-if="hasArticle"
        :article="currentFeedArticles[state.currentArticleIndex]"
        :fullscreen="state.articleViewMode === 'fullscreen'"
        @close="closeArticle"
        @toggle-fullscreen="toggleFullscreen"
        @open="openArticle"
      />
    </div>
  </div>
</template>
```

---

## 5. 验收标准

### 5.1 前端可见行为
- [ ] 执行 `npm run dev` 后，访问 `http://localhost:5180` 能加载页面
- [ ] 页面显示 FeedList、ArticleList、ArticleView 三个组件
- [ ] FeedList 显示 mock feeds 数据
- [ ] 点击 feed 后，ArticleList 显示该 feed 的文章列表
- [ ] 点击文章后，ArticleView 显示文章详情
- [ ] 点击"全屏"按钮后，ArticleView 切换为全屏模式
- [ ] 按 'q' 键后，ArticleView 关闭
- [ ] 按 'f' 键后，触发 openArticle 事件

### 5.2 交互行为
- [ ] FeedList 选中态有视觉反馈（背景色变化）
- [ ] ArticleList 选中态有视觉反馈（背景色变化）
- [ ] ArticleList 已读文章有视觉反馈（颜色变灰）
- [ ] ArticleView 全屏切换正常工作
- [ ] 键盘快捷键正常工作（q 关闭，f 打开）

### 5.3 数据流
- [ ] 状态模块正确管理 feedsList、currentFeedIndex、currentArticleIndex
- [ ] 状态切换函数正确更新状态
- [ ] 组件间通过状态模块正确通信
- [ ] 无状态不一致或索引越界问题

### 5.4 文件完整性
- [ ] 所有计划文件均已更新
- [ ] 代码无语法错误
- [ ] 构建成功（npm run build）

---

## 6. 注意事项

- 此阶段使用 mock 数据验证视图，不涉及真实数据源
- 旧 rss-reader 的"打开后找不到返回"问题，应在此阶段的状态模型里先避免：不要把详情变成不可返回的独立视图
- 组件间通过状态模块通信，避免直接 prop drilling
- 索引边界检查已修复（见 PR #3）
- 键盘快捷键在 ArticleView 组件中处理

---

## 变更记录

| 日期       | 变更内容                     | 作者 | 相关文件 |
|------------|------------------------------|------|----------|
| 2026-09-10 | 初始版本创建                | opencode | 无 |
