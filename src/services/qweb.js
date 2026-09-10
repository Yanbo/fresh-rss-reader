import { QWebChannel } from 'qwebchannel'

let pyobject = null

export const initQWebChannel = () =>
  new Promise((resolve, reject) => {
    if (typeof qt === 'undefined' || !qt.webChannelTransport) {
      console.error('QWebChannel not available in this environment')
      reject(new Error('QWebChannel not available'))
      return
    }
    new QWebChannel(qt.webChannelTransport, channel => {
      pyobject = channel.objects.pyobject
      window.pyobject = pyobject
      document.dispatchEvent(new Event('qwebchannel-ready'))
      resolve(pyobject)
    })
  })

export const getPyObject = () => pyobject
