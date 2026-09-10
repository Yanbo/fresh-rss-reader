import { createApp } from 'vue'
import App from './App.vue'
import './styles/main.css'
import { initQWebChannel } from './services/qweb.js'

const app = createApp(App)

initQWebChannel()
  .then(() => app.mount('#app'))
  .catch(() => app.mount('#app'))
