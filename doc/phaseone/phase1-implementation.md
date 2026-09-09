# Fresh RSS Reader 阶段1实现文档

创建日期：2026-09-09
项目：fresh-rss-reader
文档类型：实现文档
状态：进行中
作者：opencode
审查者：bullet, Hermes
相关文件：doc/architecture.md, doc/design-clarifications.md, doc/style-guide.md, doc/implementation-phases.md

---

## 1. 阶段目标

建立可运行的前端工程，搭好组件树和通信/状态的壳，不承载完整业务。

### 1.1 可运行边界定义

- **前端独立运行**：允许前端先独立于 Python 运行，使用 mock 数据验证视图
- **开发服务器**：通过 Vite dev server 访问入口页面
- **Mock 数据**：接受 mock 数据/桩组件验证视图结构
- **Python buffer**：阶段 1 不要求 Python buffer 完整实现，但需创建骨架文件

---

## 2. 实现步骤

### 2.1 工程初始化
- 用 Vite 初始化 Vue 3 项目
- 配置 package.json 依赖（包括 qwebchannel）
- 配置 vite.config.js 构建选项
- **Vite 输出结构**：
  ```
  dist/                  # 构建输出目录
  ├── index.html         # Python 加载入口
  └── assets/
      ├── js/            # 编译后的 JavaScript
      └── css/           # 编译后的 CSS
  ```

### 2.2 目录结构建立
- 创建 src/ 目录结构
- 建立主要模块位置

### 2.3 核心文件创建
- index.html 入口文件
- src/main.js Vue 3 入口
- src/App.vue 根组件
- src/services/qweb.js QWebChannel 封装
- src/state/useAppState.js 状态模块
- src/styles/main.css 基础样式文件
- buffer.py Python Buffer 骨架

### 2.4 组件骨架
- src/components/FeedList.vue
- src/components/ArticleList.vue
- src/components/ArticleView.vue

---

## 3. 文件清单

| 文件路径 | 说明 | 状态 | 备注 |
|----------|------|------|------|
| package.json | 前端依赖配置 | 计划创建 | 包含 qwebchannel 依赖 |
| vite.config.js | Vite 构建配置 | 计划创建 | 输出到 dist/ 目录 |
| index.html | 入口 HTML | 计划创建 | 引入 src/main.js |
| src/main.js | Vue 3 入口 | 计划创建 | 初始化 Vue 应用 |
| src/App.vue | 根组件 | 计划创建 | 整合状态和组件 |
| src/services/qweb.js | QWebChannel 封装 | 计划创建 | 统一初始化和导出 |
| src/state/useAppState.js | 状态模块 | 计划创建 | 定义状态和方法 |
| src/styles/main.css | 基础样式 | 计划创建 | CSS 变量定义 |
| src/components/FeedList.vue | Feed 列表组件 | 计划创建 | 预留 props/emits |
| src/components/ArticleList.vue | 文章列表组件 | 计划创建 | 预留 props/emits |
| src/components/ArticleView.vue | 文章详情组件 | 计划创建 | 支持 inline/fullscreen |
| buffer.py | Python Buffer 骨架 | 计划创建 | 继承 BrowserBuffer |

---

## 4. 实现细节

### 4.1 Vite 配置

**关键配置**：
```javascript
// vite.config.js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  build: {
    outDir: 'dist',  // Python 加载入口目录
    emptyOutDir: true
  },
  server: {
    port: 5173,  // 开发服务器端口
    host: true
  }
})
```

**与 Python 加载关系**：
- 开发阶段：`npm run dev` 启动开发服务器，访问 `http://localhost:5173`
- 生产阶段：`npm run build` 构建到 `dist/` 目录，Python 通过 QWebEngineView 加载 `dist/index.html`

### 4.2 QWebChannel 封装

**初始化代码**：
```javascript
// src/services/qweb.js
import QWebChannel from 'qwebchannel'

let pyobject = null

export const initQWebChannel = () => {
  return new Promise((resolve, reject) => {
    if (typeof qt === 'undefined' || !qt.webChannelTransport) {
      console.error('QWebChannel not available in this environment')
      reject(new Error('QWebChannel not available'))
      return
    }

    const channel = new QWebChannel(qt.webChannelTransport, channel => {
      pyobject = channel.objects.pyobject
      window.pyobject = pyobject
      document.dispatchEvent(new Event('qwebchannel-ready'))
      resolve(pyobject)
    })
  })
}

export const getPyObject = () => pyobject
```

**使用方式**：
```javascript
// src/main.js
import { initQWebChannel } from './services/qweb.js'

initQWebChannel()
  .then(() => {
    // 初始化 Vue 应用
  })
  .catch(error => {
    console.error('Failed to initialize QWebChannel:', error)
  })
```

### 4.3 状态模块

**最小状态字段**：
```javascript
// src/state/useAppState.js
import { reactive, readonly } from 'vue'

export const useAppState = () => {
  const state = reactive({
    feedsList: [],
    currentFeedIndex: -1,
    currentArticleIndex: -1,
    articleViewMode: 'inline',  // 'inline' | 'fullscreen'
    feedsLinkList: []
  })

  // 状态改变函数
  function selectFeed(index) { state.currentFeedIndex = index }
  function selectArticle(index) { state.currentArticleIndex = index }
  function openArticle() { /* 打开文章逻辑 */ }
  function closeArticle() { state.currentArticleIndex = -1 }
  function toggleFullscreen() {
    state.articleViewMode = state.articleViewMode === 'inline' ? 'fullscreen' : 'inline'
  }
  function markArticleRead() { /* 标记已读逻辑 */ }
  function addFeed(feed) { state.feedsList.push(feed) }
  function removeFeed(index) { state.feedsList.splice(index, 1) }

  return {
    state: readonly(state),
    selectFeed,
    selectArticle,
    openArticle,
    closeArticle,
    toggleFullscreen,
    markArticleRead,
    addFeed,
    removeFeed
  }
}
```

### 4.4 组件间通信机制

**通信方式**：通过 `useAppState.js` 进行状态管理，避免直接 prop drilling

**App.vue 中统一初始化**：
```javascript
// src/App.vue
import { useAppState } from './state/useAppState.js'

const appState = useAppState()

// 将状态和方法传递给子组件
// <FeedList :state="appState.state" :select-feed="appState.selectFeed" />
```

**组件接口约定**：
- **FeedList.vue**：接收 `state.feedsList`，触发 `selectFeed` 事件
- **ArticleList.vue**：接收 `state.feedsList[state.currentFeedIndex].articles`，触发 `selectArticle` 事件
- **ArticleView.vue**：接收当前文章数据，触发 `closeArticle` 事件

### 4.5 Python Buffer 骨架

```python
# buffer.py
from eaf.core.webengine import BrowserBuffer

class AppBuffer(BrowserBuffer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # 预留方法签名
        pass

    # 后续阶段实现的业务方法
    # def open_article(self):
    #     pass
    # def close_article(self):
    #     pass
```

### 4.6 基础样式文件

```css
/* src/styles/main.css */
:root {
  --bg-color: #ffffff;
  --fg-color: #000000;
  --select-color: #e0e0e0;
  --read-color: #888888;
  --line-color: #cccccc;
  /* 后续从 Emacs 主题获取 */
}

body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: var(--bg-color);
  color: var(--fg-color);
}
```

---

## 5. 验收标准

### 5.1 前端可见行为
- [ ] 执行 `npm run dev` 后，访问 `http://localhost:5173` 能加载页面
- [ ] 浏览器控制台无 JavaScript 错误
- [ ] 页面中存在 App.vue 渲染的根 div（可通过 DOM 检查）
- [ ] 页面显示 FeedList、ArticleList、ArticleView 的占位结构

### 5.2 通信结构就绪
- [ ] `src/services/qweb.js` 包含 `new QWebChannel(...)` 代码
- [ ] `src/services/qweb.js` 导出 `initQWebChannel` 和 `getPyObject` 函数
- [ ] `src/state/useAppState.js` 包含 `reactive` 和导出函数

### 5.3 文件完整性
- [ ] `index.html` 引入 `src/main.js`
- [ ] `src/styles/main.css` 文件存在且包含 CSS 变量定义
- [ ] `buffer.py` 文件存在且包含 `AppBuffer` 类定义
- [ ] 所有计划文件均按清单创建

### 5.4 文档合规性
- [ ] 元信息块包含"相关文件"字段
- [ ] 变更记录表包含"相关文件"列
- [ ] 文件清单状态使用"计划创建"

---

## 6. 注意事项

- 此阶段侧重工程骨架，不承载完整业务
- 状态模块可以先很简单，后面再充实
- 此阶段不一定需要完整实现 Python buffer，但需创建骨架
- QWebChannel 初始化需要等待 `qt.webChannelTransport` 就绪
- 组件间通过状态模块通信，避免直接 prop drilling

---

## 变更记录

| 日期       | 变更内容                     | 作者 | 相关文件 |
|------------|------------------------------|------|----------|
| 2026-09-09 | 初始版本创建                | opencode | 无 |
| 2026-09-09 | 整合审查反馈，更新文档细节 | opencode | doc/phaseone/phase1-review-report-bullet.md, doc/phaseone/phase1-review-report.md |
