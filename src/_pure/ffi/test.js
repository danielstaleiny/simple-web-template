exports.fetchHtmlAndRender = function (url) {
  return function () {
    if (
      url === window.location.pathname ||
      '/' + url === window.location.pathname
    )
      return
    return fetch(url)
      .then((res) => res.text())
      .then((ctx) => {
        const html = new DOMParser().parseFromString(ctx, 'text/html')
        document.head.innerHTML = html.head.innerHTML
        document.body.innerHTML = html.body.innerHTML
        history.pushState(history.state, document.title, url)
      })
      .catch(console.log)
  }
}

exports.loadPage = function () {
  return fetch(window.location.href)
    .then((res) => res.text())
    .then((ctx) => {
      const html = new DOMParser().parseFromString(ctx, 'text/html')
      document.head.innerHTML = html.head.innerHTML
      document.body.innerHTML = html.body.innerHTML
    })
    .catch(console.log)
}

exports.windowTarget = function () {
  return window
}
