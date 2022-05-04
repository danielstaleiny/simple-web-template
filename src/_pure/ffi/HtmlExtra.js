export function innerHTML(node) {
  return function () {
    return node.innerHTML
  }
}

export function setInnerHTML(innerHTML) {
  return function (node) {
    return function () {
      node.innerHTML = innerHTML
    }
  }
}

export function innerText(node) {
  return function () {
    return node.innerText
  }
}

export function setInnerText(innerText) {
  return function (node) {
    return function () {
      node.innerText = innerText
    }
  }
}

export function ctrlKey(event) {
  return function () {
    return event.ctrlKey || event.metaKey
  }
}
